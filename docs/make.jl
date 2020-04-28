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
    branch = "gh-pages",
    devbranch = "master",
    devurl = "dev",
    versions = ["stable" => "v^", "v#.#", "dev" => "dev"],
    push_preview = false
)
