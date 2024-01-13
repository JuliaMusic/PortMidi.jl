using PortMidi 

Pm_Initialize()

# 0. Get info about devices
for i in 0:Pm_CountDevices()-1
    info = unsafe_load(Pm_GetDeviceInfo(i))
    println(i, ": ", info.output > 0 ? "[Output ] " : "[Input] ", unsafe_string(info.name), " (", unsafe_string(info.interf), ")")
end

# 1. Select device
id = 11
print("Use: ", unsafe_string(unsafe_load(Pm_GetDeviceInfo(id)).name))

# 2. Open device 
stream = Ref{Ptr{PortMidi.PortMidiStream}}(C_NULL)
Pm_OpenOutput(stream, id, C_NULL, 0, C_NULL, C_NULL, 0)
# don't forget to call later: Pm_Close(stream[])

# 3. Send MIDI messages 
Note_ON = 0x90
Note_OFF = 0x80
C4 = 60

function play_note(stream, note, velocity, duration)
    Pm_WriteShort(stream[], 0, Pm_Message(Note_ON, note, velocity))
    sleep(duration)
    Pm_WriteShort(stream[], 0, Pm_Message(Note_OFF, note, velocity))
end

# make a random tune...
for i in 1:12
    @async play_note(stream, C4 + rand([-5,-2,0,2,5]), rand(80:120), 0.4 + 0.05*rand())
    sleep(0.5 + 0.05*rand())
end

# 4. Close device
Pm_Close(stream[])
