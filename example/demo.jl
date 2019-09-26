using Makie, CatmullClark

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

const donutpoints = [
    [-2.0, -0.5, -2.0], [-2.0, -0.5, 2.0], [2.0, -0.5, -2.0], [2.0, -0.5, 2.0],
    [-1.0, -0.5, -1.0], [-1.0, -0.5, 1.0], [1.0, -0.5, -1.0], [1.0, -0.5, 1.0],
    [-2.0, 0.5, -2.0], [-2.0, 0.5, 2.0], [2.0,  0.5, -2.0], [2.0, 0.5, 2.0],
    [-1.0, 0.5, -1.0], [-1.0, 0.5, 1.0], [1.0, 0.5, -1.0], [1.0, 0.5, 1.0]]

donutfaceindices = [
    [4, 5, 1, 0], [3, 1, 5, 7], [0, 2, 6, 4], [2, 3, 7, 6],
    [8,  9, 13, 12], [15, 13, 9, 11], [12, 14, 10, 8], [14, 15, 11, 10],
    [0, 1, 9, 8], [1, 3, 11, 9], [2, 0, 8, 10], [3, 2, 10, 11],
    [12, 13, 5, 4], [13, 15, 7, 5], [14, 12, 4, 6], [15, 14, 6, 7]]

const faces = [map(x -> Point3f0(inputpoints[x]), p .+ 1) for p in inputfaces]

scene = drawfaces(faces, :black)
display(scene)
sleep(1)

catmullclark(faces, 4, CatmullClark.displaycallback)

const donutfaces = [map(x -> Point3f0(donutpoints[x]), p .+ 1) for p in donutfaceindices]

scene2 = drawfaces(donutfaces, :black)
display(scene2)
setscene(scene2)
sleep(1)

catmullclark(donutfaces, 3, CatmullClark.displaycallback)

println("Press Enter to continue", readline())
