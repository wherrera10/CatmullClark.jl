using Documenter
using CatmullClark

makedocs(
    sitename="CatmullClark.jl",
    modules=[CatmullClark],
    pages=["index.md", "examples.md", "reference.md", "devnotes.md"],
    assets=["assets/custom.css"],
)

deploydocs(repo="github.com/wherrera10/CatmullClark.jl.git")
