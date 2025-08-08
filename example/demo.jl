using Makie, GeometryBasics, CatmullClark, GLMakie

# --- Data Definitions ---

const inputpoints = [
    [-1.0, -1.0, -1.0], [-1.0, -1.0, 1.0], [-1.0, 1.0, -1.0], [-1.0, 1.0, 1.0],
    [1.0, -1.0, -1.0], [1.0, -1.0, 1.0], [1.0, 1.0, -1.0], [1.0, 1.0, 1.0]]

const inputfaces = [
    [0, 4, 5, 1], [4, 6, 7, 5], [6, 2, 3, 7], [2, 0, 1, 3],
    [1, 5, 7, 3], [0, 2, 6, 4]]

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

const tetrapoints = [[1.0, 1.0, 1.0], [1.0, -1.0, -1.0], [-1.0, 1.0, -1.0], [-1.0, -1.0, 1.0]]

const tetrafaceindices = [[1, 2, 3], [1, 3, 4], [2, 3, 4], [1, 2, 4]]

# Update point construction to use Point3f from GeometryBasics
const faces = [map(x -> Point3f(inputpoints[x]...), p .+ 1) for p in inputfaces]
const donutfaces = [map(x -> Point3f(donutpoints[x + 1]...), p) for p in donutfaceindices]
const tetrafaces = [map(x -> Point3f(tetrapoints[x]...), p) for p in tetrafaceindices]

# --- Visualization Examples ---

# Cube, rounds toward a sphere
scene = drawfaces(faces, :black)
display(scene)
setscene(scene)
sleep(1)
catmullclark(faces, 4, CatmullClark.displaycallback)
sleep(2)

# Tetrahedron
scene2 = drawfaces(tetrafaces, :black)
display(scene2)
setscene(scene2)
sleep(2)
catmullclark(tetrafaces, 3, CatmullClark.displaycallback)
sleep(2)

# Torus
scene3 = drawfaces(donutfaces, :black)
display(scene3)
setscene(scene3)
sleep(1)
catmullclark(donutfaces, 3, CatmullClark.displaycallback)
sleep(2)

# Open shape (missing a face in cube, makes cuplike shape)
scene4 = drawfaces(faces[2:end], :black)
display(scene4)
setscene(scene4)
sleep(2)
catmullclark(faces[2:end], 3, CatmullClark.displaycallback)
sleep(2)

println("Demonstration complete. Press Enter to exit.")
readline()