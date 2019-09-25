using Documenter, OhMyREPL

makedocs(
    sitename = "CatmullClark",
    pages = Any[
        "Home" => "index.md",
        "Installation" => "installation.md",
        "Functions" => "Functions.md",
    ]
)

deploydocs(
    repo = "github.com/wherrera10/CatmullClark.jl.git",
)

