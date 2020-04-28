using Documenter, MyPackage

makedocs(;
    modules=[MyPackage],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/zekeriyasari/MyPackage.jl/blob/{commit}{path}#L{line}",
    sitename="MyPackage.jl",
    authors="Zekeriya SARI",
)

deploydocs(;
    repo="github.com/zekeriyasari/MyPackage.jl",
)
