using PortMidi, MusicTheory
using MusicTheory.PitchNames

Pm_Initialize()

# 0. Get info about devices
for i in 0:Pm_CountDevices()-1
    info = unsafe_load(Pm_GetDeviceInfo(i))
    if info.input == 0 
        println(i, ": ", unsafe_string(info.name))
    end
end

# 1. Select device
id = 7  # change this number if needed
print("Use: ", unsafe_string(unsafe_load(Pm_GetDeviceInfo(id)).name))

# 2. Open device 
stream = Ref{Ptr{PortMidi.PortMidiStream}}(C_NULL)
Pm_OpenOutput(stream, id, C_NULL, 0, C_NULL, C_NULL, 0)
# don't forget to call later: Pm_Close(stream[])

# 3. Send MIDI messages to play notes
Note_ON = 0x90
Note_OFF = 0x80
function play_note(stream, note, velocity, duration, delay = 0)
    sleep(delay)
    Pm_WriteShort(stream[], 0, Pm_Message(Note_ON, semitone(note), velocity))
    sleep(duration)
    Pm_WriteShort(stream[], 0, Pm_Message(Note_OFF, semitone(note), velocity))
end

# make a random tune using MusicTheory.jl
scale = Scale(D[3], major_scale)
notes = Iterators.take(scale, 14) |> collect
@sync begin
    N = 100
    offset = 0.99
    beat = 0.45  # ms

    @async for i in 1:N
        nt = rand(notes)
        rand() < 0.9 && @async play_note(stream, nt, rand(80:120), beat * (0.9 + 0.05*rand()))
        sleep(beat * (1 + 0.001*rand()))
    end

    @async for i in 1:N
        nt = rand(notes)
        rand() < 0.9 && @async play_note(stream, nt, rand(80:120), beat * offset* (0.9 + 0.05*rand()))
        sleep(beat * offset * (1 + 0.001*rand()))
    end
end

# 4. Close device
Pm_Close(stream[])
