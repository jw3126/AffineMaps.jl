export AffineMapped,
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

transform(amo::AbstractAffineMapped) = amo._trafo
set_transform!(amo::AbstractAffineMapped, am::AffineMap) = (amo._trafo = am; amo)

object(amo::AffineMapped) = amo._obj
set_object!(amo::AffineMapped, obj) = (amo._obj = obj; amo)

function transform!(am::AffineMap, amo::AffineMapped)
    amo._trafo = am * amo._trafo
    amo
end

transform(am::AffineMap, amo::AffineMapped) = typeof(amo)(am * transform(amo), amo.obj)

*(am::AffineMap, amo::AbstractAffineMapped) = transform(am, amo)

mapsize(amo::AbstractAffineMapped) = amo |> transform |> size
