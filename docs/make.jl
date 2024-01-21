using PortMidi
using Documenter

DocMeta.setdocmeta!(PortMidi, :DocTestSetup, :(using PortMidi); recursive=true)

makedocs(;
    modules=[PortMidi],
    authors="SteffenPL <steffen.plunder@web.de> and contributors",
    sitename="PortMidi.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaMusic.github.io/PortMidi.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Setup" => "setup.md",
    ],
)

deploydocs(;
    repo="JuliaMusic.github.com/PortMidi.jl",
    devbranch="main",
)
