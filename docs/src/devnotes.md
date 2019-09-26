
## Notes

### How many iterations?

	Generally, two iterations is enough to provide a nicely rounded figure
	if starting from one with sharp corners. If a high resolution smoothing
	is desired, up to 5 or more iterations may be likely required. More 
	iterations will take longer rendering times before the output is ready.


### Choice of display method

	The usual choice for OpenGL grahing in Julia is currently Makie. Other methods can 
  certainly be used, as long as the method can take a vector of vectors of 3 floating 
  point values:
	
    julia> using GeometryTypes

    julia> a = [Point3f0(1, 2, 3), Point3f0(4, 5, 6)]
    2-element Array{Point{3,Float32},1}:
     [1.0, 2.0, 3.0]
     [4.0, 5.0, 6.0]
	
