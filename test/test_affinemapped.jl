@testset "AffineMapped" begin
    m = randn(3,3)
    v = randn(3)
    am = AffineMap(m, v)
    obj = randn(4,5, 2)

    amo = AffineMapped(am, obj)
    @test mapsize(amo) == size(m)
    @test object(amo) === obj
    @test transform(amo) === am

    @test transform(inv(am) * amo) ≈ eye(am)
end
