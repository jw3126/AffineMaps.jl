
@testset "tests core" begin

    am = AffineMap(randn(3,3), randn(3))
    bm = AffineMap(randn(3,3), randn(3))

    @test full(am * bm) ≈ full(am) * full(bm)
    @test full(inv(am)) ≈ inv(full(am))
    @test am == am
    @test am != bm
end
