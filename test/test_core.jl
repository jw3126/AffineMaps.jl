
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
end
