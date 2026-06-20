using QiskitIBMRuntime
using Documenter

DocMeta.setdocmeta!(QiskitIBMRuntime, :DocTestSetup, :(using QiskitIBMRuntime); recursive=true)

makedocs(;
    modules=[QiskitIBMRuntime],
    authors="IBM and its contributors",
    sitename="QiskitIBMRuntime.jl",
    format=Documenter.HTML(;
        canonical="https://qiskit.github.io/QiskitIBMRuntime.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Qiskit/QiskitIBMRuntime.jl",
    devbranch="main",
)
