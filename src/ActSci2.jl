module ActSci2

include("decrements/Mortality/Mortality.jl")
include("decrements/Interest/Interest.jl")


export MortalityTable,
    q, p, qx,
    MortalityTables, TableMetaData,
    InterestRate,
    i, tvx, vx,v


end # module
