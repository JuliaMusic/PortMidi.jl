# Setup instructions for playing music

PortMidi can be used to play (virtual or electronic) musical instruments in real-time. 
In the following, we briefly outline how to configure your computer for this case.

Here, we will use two standalone virutal instruments to get a uncomplicated setup. 
The more powerful option is of course the use of a digitial audio workstation (DAW) 
which can also recived and forward MIDI data to the instruments loaded within the DAW.

> The following text is a selection of options and clearly subject to personal opinion.  

## Overview

In principle three steps are sufficient:
- Install standalone virtual instrument.
- Create MIDI output channel (with `Pm_CreateVirtualOutput` on linux and macOS, with [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html) on Windows).
- Configure instrument to listen to MIDI and sent note on/off commands to play music.

## Installation 

The easiest option is to install a _standalone_ virtual instrument such as 
- [Decent Sampler](https://www.decentsamples.com/product/decent-sampler-plugin/)
- [Vital Synth](https://vital.audio/)
- [Surge XT](https://surge-synthesizer.github.io/)
- (search the internet for your instrument of choice)

If you want to try a DAW instead (which gives also access to virtual instruments without standalone mode). A DAW allows to record audio and MIDI, arrange MIDI tracks and load virtual instruments and audio effects.

_One free open-source cross-platform option is [LMMS](https://lmms.io/). Another 'almost free' option is [Reaper](https://www.reaper.fm/index.php), which has a pretty generous trail option (just a dialog bugging at the start-up, even after the expire of the trial phase). Obviously, many free and paid alternatives exist._

## Create MIDI output channel

First, we need to create a new MIDI output channel for sending MIDI messages from Julia to the virtual instrument. On Windows this requires an extra program, for the other platforms portmidi itself can create the channel.

### Linux and macOS

On linux and macOS one can use the `Pm_CreateVirtualOutput(name::String, interface::String, deviceinfo::Ptr)` function, see [C docs](https://portmidi.github.io/portmidi_docs/group__grp__device.html#gad72a83e522ff11431c2ab1fc87508e9e) for the explaination. The third input should always be `C_NULL`. The output is either the error message or the new id.

> This part of the documentation is untested, please open an issue if the instructions no not work

```julia
using PortMidi

Pm_Initialize()

# create virtual input
interface = Sys.islinux() ? "ALSA" : "CoreMIDI"
id_or_err = Pm_CreateVirtualOutput("Julia MIDI Out", interface, C_NULL) 

# check error
if Int(id_or_err) < 0
    error("Could not open a virtual output device.\n\
           PortMidi error: '", string(id_or_err), "'")
end

# obtain ID
id = Int(id_or_err)
```

### Windows

The `Pm_CreateVirtualOutput` function is not implemented since the interface `MMSystem` does not provide a protable solution for this task. 

#### Creating a MIDI channel with loopMIDI

We can use the free program [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html) instead. 

- Install [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html). (Restart might be required.)
- Create a new MIDI channel called `loopMIDI Port` and click the `+` button.

#### Finding an existing MIDI channel with PortMIDI
After the MIDI channel is created, we just need to obtain its ID. Note that the ID index is 0-based.
_Important note: The first call of `Pm_Initialize()` needs to happen after the MIDI channel was created. Alternatively, one needs to call `Pm_Terminate()` first before `Pm_Initialize()` to obtain the correct list of current channels._

The following code uses the `Pm_GetDeviceInfo` function which returns a C pointer to a `PmDeviceInfo` which has inparticular a `name` and `output` field, which we check to get the right channel.

```julia
using PortMIDI

Pm_Initialize()

id = findfirst(x -> unsafe_string(x.name) == "loopMIDI Port" && x.output > 0, (unsafe_load(Pm_GetDeviceInfo(i)) for i in 0:Pm_CountDevices()-1))-1

if isnothing(id)
    error("Could not find MIDI channel 'loopMIDI Port'.")
end
```

### Start virtual instrument and select the MIDI channel as input

_With standalone instruments:_ We now need to select the MIDI port `Julia MIDI Out` or `loopMIDI Port` in our virtual instrument. All programs have the `options` button
in the top-left of the Window (Decent sampler/Surge XT: 'Options button', Vital: 'click the logo').
One might need to configure the audio output as well, depending on the setup.

_If using a DAW:_ Select in the options the right MIDI input and configure the audio driver for your system. Afterward, load a virtual instrument and _arm_ the track to listen to MIDI input.


### Open output channel with PortMidi

Once we have obtained the ID of a working MIDI output channel and setup the instruments, we can open the MIDI channel and send messages. Below is one small example:

Create a reference to a pointer for the MIDI stream.
```julia
stream = Ref{Ptr{PortMidi.PortMidiStream}}(C_NULL)
Pm_OpenOutput(stream, id, C_NULL, 0, C_NULL, C_NULL, 0)
# don't forget to call later: Pm_Close(stream[])
```

MIDI note messages have to be compressed into 32 bits. We can use the `Pm_Message` function for this task, see C docs on [PmEvents](https://portmidi.github.io/portmidi_docs/struct_pm_event.html) and [Pm_Message](https://portmidi.github.io/portmidi_docs/group__grp__events__filters.html#gaf1c22515214f7a2cbb1e1e8fb02602bd) for more details.

Here, we just need to know that we need to provide a note on and note off messages. That is, 
- a flag either `0x90` or `0x80` for note on/off events
- the semitone of the note we want to play `C4 = 60`
- the velocity of the keystroke

The following helper function allows us to play a note with a given duration.
```julia
Note_ON = 0x90
Note_OFF = 0x80
C4 = 60

function play_note(stream, note, velocity, duration)
    Pm_WriteShort(stream[], 0, Pm_Message(Note_ON, note, velocity))
    sleep(duration)
    Pm_WriteShort(stream[], 0, Pm_Message(Note_OFF, note, velocity))
end
```

Finally, we can play some notes:
```julia
for i in 1:12
    @async play_note(stream, C4 + rand([-5,-2,0,2,5]), rand(80:120), 0.4 + 0.05*rand())
    sleep(0.5 + 0.05*rand())
end
```
The `@async` helps us to meet the beat. However, for accurate timing one might need to use a different approach. (Ideas are welcome!)

If everything worked, you should head a small tune.

## Cleanup

Afterwards, we should close the MIDI stream and terminate PortMidi:
```julia
Pm_Close(stream[])
Pm_Terminate()
```
