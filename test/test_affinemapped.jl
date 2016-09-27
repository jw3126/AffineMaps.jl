@testset "AffineMapped" begin
    m = randn(3,2)
    v = randn(3)
    am = AffineMap(m, v)
    obj = randn(4,5)

    amo = AffineMapped(am, obj)
    @test mapsize(amo) == size(m)
    @test object(amo) === obj
    @test transform(amo) === am

end
