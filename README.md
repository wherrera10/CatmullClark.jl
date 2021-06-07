# CatmullClark.jl

[![Build status](https://ci.appveyor.com/api/projects/status/cfw6pe03rfn9qsoo?svg=true)](https://ci.appveyor.com/project/wherrera10/CatmullClark.jl)
[![Build Status](https://travis-ci.com/wherrera10/CatmullClark.jl.svg?branch=master)](https://travis-ci.org/wherrera10/CatmullClark.jl)
[![Coverage Status](https://coveralls.io/repos/github/wherrera10/CatmullClark.jl/badge.svg?service=github)](https://coveralls.io/github/wherrera10/CatmullClark.jl)

<img src="https://github.com/wherrera10/CatmullClark.jl/blob/master/docs/src/donut.png">

 Julia graphics package for 3D surface smoothing using the Catmull-Clark subdivision algorithm.

## Functions

    Face = Vector{Point3f0}

`Point3f0` is a 3-tuple of 32-bit floats for 3-dimensional space, and all `Point`s are 3D. 
A `Face` is defined by the points that are its vertices, in order.
<br /><br /><br />

    struct Edge
        p1::Point3f0
        p2::Point3f0
        Edge(a, b) = new(min(a, b), max(a, b))
    end

An `Edge` is a line segment where the two `Point`s are sorted.
<br /><br /><br />

    const colors = [:red, :green, :blue, :gold]
    const iterconfig = [0, length(colors), Scene()]

<br /><br /><br />


    catmullclarkstep(faces)

Perform a single step of Catmull-Clark subdivision of a surface. See Wikipedia or page 53
of http://graphics.stanford.edu/courses/cs468-10-fall/LectureSlides/10_Subdivision.pdf
The `faces` argument is a `Vector{Face}` of all the faces of the 3D object's surface.
Returns: a set of the new faces, usually a 4 times larger vector of smaller faces.
<br /><br /><br />

    catmullclark(faces, iters, callback=(x)->0)
Perform a multistep Catmull-Clark subdivision of a surface.
Does `iters` iterations (steps). Will call a callback function
with the results of each iteration (step) if one is provided.
Returns: the faces of the final result.
<br /><br /><br />

    drawfaces(faces, colr)
Draw a set of `Faces` using color `colr` and `Makie`.
Place this in a new `Scene` (a new output window).
<br /><br /><br />

    drawfaces!(faces, colr)
Draw a set of `Faces` using color `colr` and `Makie`.
Add the drawing to the existing scene.
<br /><br /><br />


    setscene(scene)

Set the `Scene` for display using `Makie`.
<br /><br /><br />


    displaycallback(faces)
Display a set of `Faces` using `Makie`. This can be used as a
callback to show the steps of the `catmullclark` function. See
exsmple/demo.jl in this package for an example of usage.
<br /><br /><br />

## Example

    using Makie, CatmullClark
    
    const inputpoints = [
        [-1.0, -1.0, -1.0],
        [-1.0, -1.0, 1.0],
        [-1.0, 1.0, -1.0],
        [-1.0, 1.0, 1.0],
        [1.0, -1.0, -1.0],
        [1.0, -1.0, 1.0],
        [1.0, 1.0, -1.0],
        [1.0, 1.0, 1.0]]
    
    const inputfaces = [
        [0, 4, 5, 1],
        [4, 6, 7, 5],
        [6, 2, 3, 7],
        [2, 0, 1, 3],
        [1, 5, 7, 3],
        [0, 2, 6, 4]]
    
    const donutpoints = [
        [-2.0, -0.5, -2.0], [-2.0, -0.5, 2.0], [2.0, -0.5, -2.0], [2.0, -0.5, 2.0],
        [-1.0, -0.5, -1.0], [-1.0, -0.5, 1.0], [1.0, -0.5, -1.0], [1.0, -0.5, 1.0],
        [-2.0, 0.5, -2.0], [-2.0, 0.5, 2.0], [2.0,  0.5, -2.0], [2.0, 0.5, 2.0],
        [-1.0, 0.5, -1.0], [-1.0, 0.5, 1.0], [1.0, 0.5, -1.0], [1.0, 0.5, 1.0]]
    
    const donutfaceindices = [
        [4, 5, 1, 0], [3, 1, 5, 7], [0, 2, 6, 4], [2, 3, 7, 6],
        [8,  9, 13, 12], [15, 13, 9, 11], [12, 14, 10, 8], [14, 15, 11, 10],
        [0, 1, 9, 8], [1, 3, 11, 9], [2, 0, 8, 10], [3, 2, 10, 11],
        [12, 13, 5, 4], [13, 15, 7, 5], [14, 12, 4, 6], [15, 14, 6, 7]]
    
    const tetrapoints = [[1.0, 1.0, 1.0], [1.0, -1.0, -1.0], [-1, 1, -1], [-1, -1, 1]]
    
    const tetrafaceindices = [[1, 2, 3], [1, 3, 4], [2, 3, 4], [1, 2, 4]]
    
    const faces = [map(x -> Point3f0(inputpoints[x]), p .+ 1) for p in inputfaces]
    const donutfaces = [map(x -> Point3f0(donutpoints[x]), p .+ 1) for p in donutfaceindices]
    const tetrafaces = [map(x -> Point3f0(tetrapoints[x]), p) for p in tetrafaceindices]
    
    # cube, rounds toward a sphere
    scene = drawfaces(faces, :black)
    display(scene)
    setscene(scene)
    sleep(1)
    catmullclark(faces, 4, CatmullClark.displaycallback)
    
    # tetrahedron
    scene2 = drawfaces(tetrafaces, :black)
    display(scene2)
    setscene(scene2)
    sleep(2)
    catmullclark(tetrafaces, 3, CatmullClark.displaycallback)
    
    # torus
    scene3 = drawfaces(donutfaces, :black)
    display(scene3)
    setscene(scene3)
    sleep(1)
    catmullclark(donutfaces, 3, CatmullClark.displaycallback)
    
    # if a face missing in cube, makes cuplike shape
    sleep(3)
    scene4 = drawfaces(faces[2:end], :black)
    display(scene4)
    setscene(scene4)
    sleep(2)
    catmullclark(faces[2:end], 3, CatmullClark.displaycallback)
    
    println("Press Enter to continue", readline())

<br /><br /><br />


## Installation

The package gereally requires Makie, at least for the geometry types defined via that package.

You may install the package from Github in the usual way, or to install the current master copy:

    using Pkg
    Pkg.add("http://github.com/wherrera10/CatmullClark.jl")
    
