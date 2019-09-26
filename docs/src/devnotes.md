
## Notes

### How many iterations do I need?

    Generally, two iterations is enough to provide a nicely rounded figure
    if starting from one with sharp corners. If a high resolution smoothing
    is desired, up to 5 or more iterations may be likely required. More
    iterations will take longer rendering times before the output is ready.

    A caveat: large numbers of iterations may take exponential time for completion.


### Do I have a choice of display method other than Makie?

    We think the best choice for OpenGL 3D graphing in Julia is currently Makie.

    Other methods can certainly be used, as long as the method can use the output
    from catmullclarkstep, which is a vector of faces, which are vectors of 3D
    point values defined as type Point{3, Float32}:

    julia> using GeometryTypes

    julia> a = [Point3f0(1, 2, 3), Point3f0(4, 5, 6)]
    2-element Array{Point{3,Float32},1}:
     [1.0, 2.0, 3.0]
     [4.0, 5.0, 6.0]

     The output of catmullclark can thus be used as a Vector{Vector{Vector{Float32}}},
     where the innermost vectors are always 3 floating point values.

