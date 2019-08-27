push!(LOAD_PATH,"../src/")
using Documenter, ActSci2   

makedocs(sitename="Actuarial Science v2 (WIP)")

deploydocs(
    repo = "github.com/alecloudenback/ActSci2.jl.git",
)