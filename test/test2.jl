using Makie, CatmullClark, Test

# Will display a graphic briefly, needed for code coverage.

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

const donutfaces = [map(x -> Point3f0(donutpoints[x]), p .+ 1) for p in donutfaceindices]

scene2 = drawfaces(donutfaces, :black)
setscene(scene2)
getscene()
sleep(1)
catmullclark(donutfaces, 1, CatmullClark.displaycallback)

face = donutfaces[2]

edge = CatmullClark.Edge(face[1], face[2])

@test CatmullClark.newedgepoint(CatmullClark.Edge(Point3f0(100, 100, 100),
    Point3f0(1, 1, 1)), donutfaces) == [50.5, 50.5, 50.5]


@test !CatmullClark.nexttohole(edge, donutfaces)

@test_throws String CatmullClark.adjacentpoints(Point3f0(100, 100, 100), donutfaces)

f = CatmullClark.edgesforface(face)[1]

@test f.p1[3] == 2.0

@test CatmullClark.edgemidpoint(f)[1] == 0.0

