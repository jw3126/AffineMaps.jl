export AffineMapped,
AbstractAffineMapped,
set_transform!,
transform!,
transform,
object,
set_object!,
mapsize

abstract AbstractAffineMapped

type AffineMapped{AM <: AffineMap, OBJ} <: AbstractAffineMapped
    _trafo :: AM
    _obj::OBJ
end

Base.copy(amo::AffineMapped) = typeof(amo)(amo._trafo, amo._obj)

transform{AM, OBJ}(::Type{AffineMapped{AM, OBJ}}) = AM
transform(amo::AbstractAffineMapped) = amo._trafo
set_transform!(amo::AbstractAffineMapped, am::AffineMap) = (amo._trafo = am; amo)

object{AM, OBJ}(::Type{AffineMapped{AM, OBJ}}) = OBJ
object(amo::AffineMapped) = amo._obj
set_object!(amo::AffineMapped, obj) = (amo._obj = obj; amo)

function transform!(am::AffineMap, amo::AbstractAffineMapped)
    amo._trafo = am * amo._trafo
    amo
end

transform(am::AffineMap, amo::AbstractAffineMapped) = transform!(am, copy(amo))

*(am::AffineMap, amo::AbstractAffineMapped) = transform(am, amo)

mapsize{AMO <: AbstractAffineMapped}(::Type{AMO}) = AMO |> transform |> size
mapsize(amo::AbstractAffineMapped) = amo |> transform |> size

function Base.rand{AM, OBJ}(AMO::Type{AffineMapped{AM, OBJ}})
    AMO(rand(AM), rand(OBJ))
end
