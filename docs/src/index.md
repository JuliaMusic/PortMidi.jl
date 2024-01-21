```@meta
CurrentModule = PortMidi
```

# PortMidi

Documentation for [PortMidi](https://github.com/SteffenPL/PortMidi.jl).

A Julia wrapper for the C library [PortMidi](https://github.com/PortMidi/portmidi). 
See the [C documentation](https://portmidi.github.io/portmidi_docs/) for a list of functions. 

## Current state

At this point, the package has not much Julia specific helper functions. Such helper functions will be developed in the future but we aim to keep the design as minimal as possible to remain as portable as the underlying C library.

## Example

See the `examples` folder for two small test cases. 

## Playing music

A more detailed tutorial on how to use PortMidi for real time control of virtual instruments, see  [Setup](./setup.md).