


@testset "tests core" begin

    am = AffineMap(randn(3,3), randn(3))
    bm = AffineMap(randn(3,3), randn(3))
    v = randn(3)

    @test size(am) == (3,3)
    @test full(am * bm) ≈ full(am) * full(bm)
    @test full(inv(am)) ≈ inv(full(am))
    @test [am*v; 1] ≈ full(am) * [v; 1]
    @test am == am
    @test am != bm
    @test am * v == matrix(am) * v + offset(am)

    # exotic shape
    vs = randn(3, 10)
    @test am * vs == matrix(am) * vs .+ offset(am)

    # full
    am = AffineMap([1 2 3; 4 5 6], [10, 20])
    @test full(am) == [1 2 3 10; 4 5 6 20; 0 0 0 1]

    # conversion
    m = AffineMap(rand(1:100, 3,2), rand(1:100, 3))
    MF = AffineMap{Matrix{Float64}, Vector{Float64}}
    mf = MF(m)
    @test eltype(m) == Int
    @test mf == m
    @test eltype(mf) == Float64

    #

end
