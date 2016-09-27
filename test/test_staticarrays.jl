using StaticArrays

@testset "test static arrays" begin
    m = @SMatrix [1 2 3; 4 5 6]
    v = @SVector [1, 2]

    M = typeof(m)
    V = typeof(v)
    am = @inferred AffineMap(m, v)
    AM = typeof(am)
    @test AM == AffineMap{M, V}
    @test size(AM) == (2, 3)

    @test eltype(AM) == Int

    @test eye(AM) == AffineMap((@SMatrix [1 0 0; 0 1 0]), (@SVector [0, 0]))
    @test am ≈ am
    @test full(am) == full(am)
    @test am == am

    @test am ≉ eye(am)

    @inferred rand(AM)
    @inferred zeros(am)

end
