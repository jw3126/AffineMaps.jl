export AffineMap, matrix, offset, dimto, dimfrom

import Base: size, *, inv, ==, full, eltype, isapprox, eye, convert, zeros, rand, randn

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
eltype{M,V}(::Type{AffineMap{M,V}}) = eltype(M)

offset(m::AffineMap) = m.offset
matrix(m::AffineMap) = m.mat

dimto(am::AffineMap) = size(am, 1)
dimfrom(am::AffineMap) = size(am, 2)

size{M,V}(::Type{AffineMap{M,V}}, dim...) = size(M, dim...)
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
    out = zeros(eltype(am), N,M)
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

isapprox(am1::AffineMap, am2::AffineMap; kw...) = isapprox(full(am1), full(am2); kw...)

eye{M,V}(::Type{AffineMap{M, V}}) = AffineMap(eye(M), zeros(V))
eye(am::AffineMap) = eye(typeof(am))

for fun in [:zeros, :rand, :randn]
    @eval ($fun){M,V}(::Type{AffineMap{M, V}}) = AffineMap(($fun)(M), ($fun)(V))
    @eval ($fun)(am::AffineMap) = ($fun)(typeof(am))
end

convert{M,V}(AM::Type{AffineMap{M,V}}, am::AffineMap) = AM(M(am.mat), V(am.offset))
