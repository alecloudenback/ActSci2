using ActSci2
using Test

@testset "basic `Ultimate` MortalityTable" begin
    tbl = Ultimate([i/100 for i in 1:100])
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
    tbl = Ultimate([i/100 for i in 5:100],5)
    @test_throws BoundsError q(tbl,0)
    @test q(tbl,5) ≈ 0.05
    @test q(tbl,5,1) ≈ 0.05
    @test q(tbl,5,2) ≈ 1.0 - (1.0 - 0.05) * (1.0 - 0.06)


    @test p(tbl,5) ≈ 0.95
    @test p(tbl,5,1) ≈ 0.95
    @test p(tbl,5,2) ≈ 1.0 - q(tbl,5,2)

    @test q(tbl,5,1,1) ≈ 0.06
    @test p(tbl,5,1,1) ≈ 0.94
end
