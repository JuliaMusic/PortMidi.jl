module PortMidi

using PortMidi_jll
export PortMidi_jll

using CEnum

const PmQueue = Cvoid

function Pm_QueueFull(queue)
    ccall((:Pm_QueueFull, libportmidi), Cint, (Ptr{PmQueue},), queue)
end

function Pm_QueueEmpty(queue)
    ccall((:Pm_QueueEmpty, libportmidi), Cint, (Ptr{PmQueue},), queue)
end

function Pm_QueuePeek(queue)
    ccall((:Pm_QueuePeek, libportmidi), Ptr{Cint}, (Ptr{PmQueue},), queue)
end

const PortMidiStream = Cvoid

@cenum PmError::Int32 begin
    pmNoError = 0
    pmNoData = 0
    pmGotData = 1
    pmHostError = -10000
    pmInvalidDeviceId = -9999
    pmInsufficientMemory = -9998
    pmBufferTooSmall = -9997
    pmBufferOverflow = -9996
    pmBadPtr = -9995
    pmBadData = -9994
    pmInternalError = -9993
    pmBufferMaxSize = -9992
    pmNotImplemented = -9991
    pmInterfaceNotSupported = -9990
    pmNameConflict = -9989
end

function Pm_Initialize()
    ccall((:Pm_Initialize, libportmidi), PmError, ())
end

function Pm_Terminate()
    ccall((:Pm_Terminate, libportmidi), PmError, ())
end

function Pm_HasHostError(stream)
    ccall((:Pm_HasHostError, libportmidi), Cint, (Ptr{PortMidiStream},), stream)
end

function Pm_GetErrorText(errnum)
    ccall((:Pm_GetErrorText, libportmidi), Ptr{Cchar}, (PmError,), errnum)
end

function Pm_GetHostErrorText(msg, len)
    ccall((:Pm_GetHostErrorText, libportmidi), Cvoid, (Ptr{Cchar}, Cuint), msg, len)
end

const PmDeviceID = Cint

struct PmDeviceInfo
    structVersion::Cint
    interf::Ptr{Cchar}
    name::Ptr{Cchar}
    input::Cint
    output::Cint
    opened::Cint
    is_virtual::Cint
end

function Pm_CountDevices()
    ccall((:Pm_CountDevices, libportmidi), Cint, ())
end

function Pm_GetDefaultInputDeviceID()
    ccall((:Pm_GetDefaultInputDeviceID, libportmidi), PmDeviceID, ())
end

function Pm_GetDefaultOutputDeviceID()
    ccall((:Pm_GetDefaultOutputDeviceID, libportmidi), PmDeviceID, ())
end

const int32_t = Cint

const PmTimestamp = int32_t

# typedef PmTimestamp ( * PmTimeProcPtr ) ( void * time_info )
const PmTimeProcPtr = Ptr{Cvoid}

function Pm_GetDeviceInfo(id)
    ccall((:Pm_GetDeviceInfo, libportmidi), Ptr{PmDeviceInfo}, (PmDeviceID,), id)
end

function Pm_OpenInput(stream, inputDevice, inputDriverInfo, bufferSize, time_proc, time_info)
    ccall((:Pm_OpenInput, libportmidi), PmError, (Ptr{Ptr{PortMidiStream}}, PmDeviceID, Ptr{Cvoid}, int32_t, PmTimeProcPtr, Ptr{Cvoid}), stream, inputDevice, inputDriverInfo, bufferSize, time_proc, time_info)
end

function Pm_OpenOutput(stream, outputDevice, outputDriverInfo, bufferSize, time_proc, time_info, latency)
    ccall((:Pm_OpenOutput, libportmidi), PmError, (Ptr{Ptr{PortMidiStream}}, PmDeviceID, Ptr{Cvoid}, int32_t, PmTimeProcPtr, Ptr{Cvoid}, int32_t), stream, outputDevice, outputDriverInfo, bufferSize, time_proc, time_info, latency)
end

function Pm_CreateVirtualInput(name, interf, deviceInfo)
    ccall((:Pm_CreateVirtualInput, libportmidi), PmError, (Ptr{Cchar}, Ptr{Cchar}, Ptr{Cvoid}), name, interf, deviceInfo)
end

function Pm_CreateVirtualOutput(name, interf, deviceInfo)
    ccall((:Pm_CreateVirtualOutput, libportmidi), PmError, (Ptr{Cchar}, Ptr{Cchar}, Ptr{Cvoid}), name, interf, deviceInfo)
end

function Pm_DeleteVirtualDevice(device)
    ccall((:Pm_DeleteVirtualDevice, libportmidi), PmError, (PmDeviceID,), device)
end

function Pm_SetFilter(stream, filters)
    ccall((:Pm_SetFilter, libportmidi), PmError, (Ptr{PortMidiStream}, int32_t), stream, filters)
end

function Pm_SetChannelMask(stream, mask)
    ccall((:Pm_SetChannelMask, libportmidi), PmError, (Ptr{PortMidiStream}, Cint), stream, mask)
end

function Pm_Abort(stream)
    ccall((:Pm_Abort, libportmidi), PmError, (Ptr{PortMidiStream},), stream)
end

function Pm_Close(stream)
    ccall((:Pm_Close, libportmidi), PmError, (Ptr{PortMidiStream},), stream)
end

function Pm_Synchronize(stream)
    ccall((:Pm_Synchronize, libportmidi), PmError, (Ptr{PortMidiStream},), stream)
end

const uint32_t = Cuint

const PmMessage = uint32_t

struct PmEvent
    message::PmMessage
    timestamp::PmTimestamp
end

function Pm_Read(stream, buffer, length)
    ccall((:Pm_Read, libportmidi), Cint, (Ptr{PortMidiStream}, Ptr{PmEvent}, int32_t), stream, buffer, length)
end

function Pm_Poll(stream)
    ccall((:Pm_Poll, libportmidi), PmError, (Ptr{PortMidiStream},), stream)
end

function Pm_Write(stream, buffer, length)
    ccall((:Pm_Write, libportmidi), PmError, (Ptr{PortMidiStream}, Ptr{PmEvent}, int32_t), stream, buffer, length)
end

function Pm_WriteShort(stream, when, msg)
    ccall((:Pm_WriteShort, libportmidi), PmError, (Ptr{PortMidiStream}, PmTimestamp, PmMessage), stream, when, msg)
end

function Pm_WriteSysEx(stream, when, msg)
    ccall((:Pm_WriteSysEx, libportmidi), PmError, (Ptr{PortMidiStream}, PmTimestamp, Ptr{Cuchar}), stream, when, msg)
end

@cenum PtError::Int32 begin
    ptNoError = 0
    ptHostError = -10000
    ptAlreadyStarted = -9999
    ptAlreadyStopped = -9998
    ptInsufficientMemory = -9997
end

const PtTimestamp = int32_t

# typedef void ( PtCallback ) ( PtTimestamp timestamp , void * userData )
const PtCallback = Cvoid

function Pt_Start(resolution, callback, userData)
    ccall((:Pt_Start, libportmidi), PtError, (Cint, Ptr{PtCallback}, Ptr{Cvoid}), resolution, callback, userData)
end

function Pt_Stop()
    ccall((:Pt_Stop, libportmidi), PtError, ())
end

function Pt_Started()
    ccall((:Pt_Started, libportmidi), Cint, ())
end

function Pt_Time()
    ccall((:Pt_Time, libportmidi), PtTimestamp, ())
end

function Pt_Sleep(duration)
    ccall((:Pt_Sleep, libportmidi), Cvoid, (int32_t,), duration)
end

const FALSE = 0

const TRUE = 1

const PM_DEFAULT_SYSEX_BUFFER_SIZE = 1024

const PmStream = PortMidiStream

const PM_HOST_ERROR_MSG_LEN = Cuint(256)

const pmNoDevice = -1

const PM_DEVICEINFO_VERS = 200

const PM_FILT_ACTIVE = 1 << 0x0e

const PM_FILT_SYSEX = 1 << 0x00

const PM_FILT_CLOCK = 1 << 0x08

const PM_FILT_PLAY = (1 << 0x0a | 1 << 0x0c) | 1 << 0x0b

const PM_FILT_TICK = 1 << 0x09

const PM_FILT_FD = 1 << 0x0d

const PM_FILT_UNDEFINED = PM_FILT_FD

const PM_FILT_RESET = 1 << 0x0f

const PM_FILT_REALTIME = (((((PM_FILT_ACTIVE | PM_FILT_SYSEX) | PM_FILT_CLOCK) | PM_FILT_PLAY) | PM_FILT_UNDEFINED) | PM_FILT_RESET) | PM_FILT_TICK

const PM_FILT_NOTE = 1 << 0x19 | 1 << 0x18

const PM_FILT_CHANNEL_AFTERTOUCH = 1 << 0x1d

const PM_FILT_POLY_AFTERTOUCH = 1 << 0x1a

const PM_FILT_AFTERTOUCH = PM_FILT_CHANNEL_AFTERTOUCH | PM_FILT_POLY_AFTERTOUCH

const PM_FILT_PROGRAM = 1 << 0x1c

const PM_FILT_CONTROL = 1 << 0x1b

const PM_FILT_PITCHBEND = 1 << 0x1e

const PM_FILT_MTC = 1 << 0x01

const PM_FILT_SONG_POSITION = 1 << 0x02

const PM_FILT_SONG_SELECT = 1 << 0x03

const PM_FILT_TUNE = 1 << 0x06

const PM_FILT_SYSTEMCOMMON = ((PM_FILT_MTC | PM_FILT_SONG_POSITION) | PM_FILT_SONG_SELECT) | PM_FILT_TUNE

end # module
