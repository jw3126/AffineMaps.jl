export AffineMap

import Base: size, +, *, inv, ==, full, eltype

immutable AffineMap{M,V}
    mat::M
    offset::V
    function AffineMap(m::M, v::V)
        @assert ndims(m) == 2
        @assert ndims(v) == 1
        @assert size(m, 1) == size(v, 1)
        @assert eltype(m) == eltype(v)
        return new(m,v)
    end
end

# now that looks strange
AffineMap{M, V}(m::M, v::V) = AffineMap{M,V}(m,v)

eltype(am::AffineMap) = eltype(am.mat)

size(am::AffineMap, dim...) = size(am.mat, dim...)
*(am::AffineMap, bm::AffineMap) = AffineMap(am.mat * bm.mat, am.offset + am.mat * bm.offset)
*(am::AffineMap, obj) = am.mat*obj + am.offset
function inv(am::AffineMap)
    imat = inv(am.mat)
    AffineMap(imat, -imat*am.offset)
end
==(am::AffineMap, bm::AffineMap) = (am.mat == bm.mat) & (am.offset == bm.offset)

function full(am::AffineMap)
    n,m = size(am)
    N = n+1; M = m+1
    out = Array(eltype(am), N,M)
    @inbounds begin
        for i in 1:n, j in 1:m
            out[i,j] = am.mat[i,j]
        end
        out[N,M] = one(eltype(am))
        for i in 1:n
            out[i, M] = am.offset[i]
        end
    end
    out
end
