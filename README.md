# AffineMaps
[![Build Status](https://travis-ci.org/jw3126/AffineMaps.jl.svg?branch=master)](https://travis-ci.org/jw3126/AffineMaps.jl)
[![Coverage Status](https://coveralls.io/repos/github/jw3126/AffineMaps.jl/badge.svg?branch=master)](https://coveralls.io/github/jw3126/AffineMaps.jl?branch=master)
## Relation to AffineTransforms.jl
[AffineTransforms.jl](https://github.com/timholy/AffineTransforms.jl) is about invertible affine transforms, while this package is about not necessarily invertible ones. Also AffineMaps uses Base.Matrix and Base.Vector, while this package is meant to be used with [FixedSizeArrays.jl](https://github.com/SimonDanisch/FixedSizeArrays.jl) or [StaticArrays.jl](https://github.com/andyferris/StaticArrays.jl).
