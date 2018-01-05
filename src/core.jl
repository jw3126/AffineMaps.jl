export AffineMap, matrix, offset, dimto, dimfrom

import Base: size, *, inv, ==, full, eltype, isapprox, eye, convert, zeros, rand, randn

struct AffineMap{M,V}
    mat::M
    offset::V
    function AffineMap{M,V}(m::M, v::V) where {M,V}
        @assert ndims(m) == 2
        @assert ndims(v) == 1
        @assert size(m, 1) == size(v, 1)
        @assert eltype(m) == eltype(v)
        return new(m,v)
    end
end
AffineMap(m::M, v::V) where {M,V} = AffineMap{M,V}(m,v)

eltype(am::AffineMap) = eltype(am.mat)
eltype(::Type{AffineMap{M,V}}) where {M,V} = eltype(M)

offset(m::AffineMap) = m.offset
matrix(m::AffineMap) = m.mat

dimto(am::AffineMap) = size(am, 1)
dimfrom(am::AffineMap) = size(am, 2)

size(::Type{AffineMap{M,V}}, dim...) where {M,V} = size(M, dim...)
size(am::AffineMap, dim...) = size(am.mat, dim...)

*(am::AffineMap, bm::AffineMap) = AffineMap(am.mat * bm.mat, am.offset + am.mat * bm.offset)
*(am::AffineMap, v::AbstractVector) = am.mat*v + am.offset  # extra method for vector to have nicer output type
*(am::AffineMap, obj) = am.mat*obj .+ am.offset  # e.g. am * matrix whose columns are vectors

# Some of these are questionable operations, do we want them?
for op in (:+, :-)
    @eval Base.$op(am::AffineMap, bm::AffineMap) = AffineMap($op(am.mat, bm.mat), $op(am.offset, bm.offset))
end

function inv(am::AffineMap)
    imat = inv(am.mat)
    AffineMap(imat, -imat*am.offset)
end
==(am::AffineMap, bm::AffineMap) = (am.mat == bm.mat) & (am.offset == bm.offset)

function full(am::AffineMap)
    T = eltype(am)
    n, m = size(am)
    N, M = n+1, m+1
    out = Array{T}( N, M)
    @inbounds begin
        for j in 1:m, i in 1:n
            out[i,j] = am.mat[i,j]
        end
        out[N,M] = one(T)
        for i in 1:n
            out[i, M] = am.offset[i]
        end
        for j in 1:m
            out[N, j] = zero(T)
        end
    end
    out
end

isapprox(am1::AffineMap, am2::AffineMap; kw...) = isapprox(full(am1), full(am2); kw...)

eye(::Type{AffineMap{M, V}}) where {M,V} = AffineMap(eye(M), zeros(V))
eye(am::AffineMap) = typeof(am)(eye(matrix(am)), zeros(offset(am)))

for fun in [:zeros, :rand, :randn]
    @eval ($fun)(::Type{AffineMap{M, V}}) where {M,V} = AffineMap(($fun)(M), ($fun)(V))
    @eval ($fun)(am::AffineMap) = ($fun)(typeof(am))
end

convert(AM::Type{AffineMap{M,V}}, am::AffineMap) where {M,V} = AM(M(am.mat), V(am.offset))
