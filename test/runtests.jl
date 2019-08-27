using ActSci2
using Test

@testset "utility functions" begin

    @testset "normalization of input vector" begin
    v = [1, 2, 3]
    f1 = ActSci2.normalized_vector
    c = f1(v) 
    @test c[0] == 1
    @test c[1] == 2
    @test c[2] == 3
    @test ismissing(c[3])
    @test ismissing(c[120])
    @test_throws  BoundsError  c[121]


    f2 = ActSci2.ultimate_vector_to_matrix
    
    c = f2(v)

    @test c[0,1] == 1
    @test c[0,2] == 2
    @test c[0,3] == 3
    @test ismissing(c[0,4] )
    @test ismissing(c[0,120] )
    @test ismissing(c[0,121] )
    @test c[1,1] == 2
    @test c[1,2] == 3
    @test ismissing(c[1,3] )
    end
end

@testset "basic `Ultimate` MortalityTable" begin
    tbl = MortalityTable([i/100 for i in 1:100],0)
    @test q(tbl,0,1) ≈ 0.01
    @test q(tbl,0,2) ≈ 1.0 - (1.0 - 0.01) * (1.0 - 0.02)
    @test q(tbl,0) ≈ 0.01

    @test p(tbl,0) ≈ 0.99
    @test p(tbl,0,1) ≈ 0.99
    @test p(tbl,0,2) ≈ 1.0 - q(tbl,0,2)
    @test q(tbl,0,1,1) ≈ 0.02
    @test p(tbl,0,1,1) ≈ 0.98
    @test_throws BoundsError q(tbl,200)
end

@testset "basic `Ultimate` MortalityTable with non-zero start age" begin
    tbl = MortalityTable([i/100 for i in 5:100],5)
    @test ismissing(q(tbl,0))
    @test q(tbl,5) ≈ 0.05
    @test q(tbl,5,1) ≈ 0.05
    @test q(tbl,5,2) ≈ 1.0 - (1.0 - 0.05) * (1.0 - 0.06)


    @test p(tbl,5) ≈ 0.95
    @test p(tbl,5,1) ≈ 0.95
    @test p(tbl,5,2) ≈ 1.0 - q(tbl,5,2)

    @test q(tbl,5,1,1) ≈ 0.06
    @test p(tbl,5,1,1) ≈ 0.94
end

@testset "test table names" begin
    tbl = MortalityTable([i/100 for i in 1:100],0,TableMetaData(name="test"))
    @test q(tbl,0,1) ≈ 0.01
    @test tbl.d.name == "test"
end



@testset "SOA tables" begin
    
    tables = MortalityTables()
    cso2001 = tables["2001 CSO Super Preferred Select and Ultimate - Male Nonsmoker, ANB"]
    vbt2001 = tables["2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB"]
    cso1980 = tables["1980 CSO Basic Table – Male, ANB"]

    @test q(cso1980,35,0,1) ≈ .00118
    @test qx(cso1980,35,1) ≈ .00118
    @test qx(cso1980,35,61) ≈ .27302
    @test qx(cso1980,95) ≈ .27302
    @test ismissing(qx(cso1980,35,95))
    @test ismissing(qx(cso1980,101))

    @test qx(cso2001,35,1) ≈ .00037
    @test qx(cso2001,35,61) ≈ .26719
    @test qx(cso2001,16) ≈ .00041
    @test qx(cso2001,95) ≈ .26719
    @test ismissing(qx(cso2001,15))
    @test_throws BoundsError qx(cso2001,150)
    @test ismissing(qx(cso2001,35,95))

    @test qx(vbt2001,35,1) ≈ .00036
    @test qx(vbt2001,35,61) ≈ .24298
    @test qx(vbt2001,95) ≈ .24298
    @test ismissing(qx(vbt2001,35,95))
    @test_throws BoundsError qx(vbt2001,150)

    @test cso2001[29,1:3] == [0.00029, 0.00035, 0.0004]

end

include("interest.jl")