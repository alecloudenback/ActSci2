################
# Interest Rates
################

using Distributions

@testset "interest rates" begin

    ## functional interest rate
    @testset "functional interest rate" begin
        i1 = InterestRate((x -> .05))

        @test   v(i1) == 1/(1.05) 
        @test   vx(i1,1) == 1/(1.05) 
        @test   tvx(i1,2,1) == 1/(1.05^2) 
        @test   i(i1,1) == .05 
    end

    ## vector interest rate
    @testset "vector interest rate" begin
        i2 = InterestRate([.05,.05,.05])
        @test   v(i2) == 1/(1.05) 
        @test   vx(i2,1) == 1/(1.05) 
        @test   tvx(i2,2,1) == 1/(1.05^2) 
    end

    ## real interest rate
    @testset "constant interest rate" begin
        i3 = InterestRate(.05)

        @test   v(i3) == 1/(1.05) 
        @test   vx(i3,1) == 1/(1.05) 
        @test   tvx(i3,2,1) == 1/(1.05^2) 
        @test 1/(1.05^120) ≈ tvx(i3,120,1)
    end

    ## Stochastic interest rate
    @testset "stochastic interest rate" begin
        i4 = InterestRate((x -> rand(Normal(0.05,0.01))))
        i5 = InterestRate((x -> rand(Normal(i(i5,-1),0.01))), .05)

        @test v(i4) > 0
        @test v(i5) > 0
        @test tvx(i4,120,1) > 0
        @test tvx(i5,120,1) > 0
    end
end