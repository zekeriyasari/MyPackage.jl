using Documenter, MyPackage

makedocs(;
    modules=[MyPackage],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/zekeriyasari/MyPackage.jl.git",
    sitename="MyPackage.jl",
    authors="Zekeriya SARI",
)

deploydocs(;
    repo="github.com/zekeriyasari/MyPackage.jl.git",
    devbranch = "master",
    devurl = "dev",
    versions = ["stable" => "v^", "v#.#", devurl => devurl],
)
