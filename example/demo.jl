using Makie, CatmullClark, CatmullClarkGraphics

const inputpoints = [
    [-1.0, -1.0, -1.0],
    [-1.0, -1.0, 1.0],
    [-1.0, 1.0, -1.0],
    [-1.0, 1.0, 1.0],
    [1.0, -1.0, -1.0],
    [1.0, -1.0, 1.0],
    [1.0, 1.0, -1.0],
    [1.0, 1.0, 1.0]
]

const inputfaces = [
    [0, 4, 5, 1],
    [4, 6, 7, 5],
    [6, 2, 3, 7],
    [2, 0, 1, 3],
    [1, 5, 7, 3],
    [0, 2, 6, 4]
]

const faces = [map(x -> Point3f0(inputpoints[x]), p .+ 1) for p in inputfaces]

scene = drawfaces(faces, :black)
display(scene)
sleep(1)

catmullclark(faces, 4, CatmullClarkGraphics.displaycallback)

println("Press Enter to continue", readline())

