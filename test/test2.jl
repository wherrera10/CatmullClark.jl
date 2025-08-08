@testset "test 2" begin
    donutpoints = [
        [-2.0, -0.5, -2.0], [-2.0, -0.5, 2.0], [2.0, -0.5, -2.0], [2.0, -0.5, 2.0],
        [-1.0, -0.5, -1.0], [-1.0, -0.5, 1.0], [1.0, -0.5, -1.0], [1.0, -0.5, 1.0],
        [-2.0, 0.5, -2.0], [-2.0, 0.5, 2.0], [2.0,  0.5, -2.0], [2.0, 0.5, 2.0],
        [-1.0, 0.5, -1.0], [-1.0, 0.5, 1.0], [1.0, 0.5, -1.0], [1.0, 0.5, 1.0]]

    donutfaceindices = [
        [4, 5, 1, 0], [3, 1, 5, 7], [0, 2, 6, 4], [2, 3, 7, 6],
        [8,  9, 13, 12], [15, 13, 9, 11], [12, 14, 10, 8], [14, 15, 11, 10],
        [0, 1, 9, 8], [1, 3, 11, 9], [2, 0, 8, 10], [3, 2, 10, 11],
        [12, 13, 5, 4], [13, 15, 7, 5], [14, 12, 4, 6], [15, 14, 6, 7]]

    # Updated to use Point3f
    donutfaces = [map(x -> Point3f(donutpoints[x + 1]...), p) for p in donutfaceindices]

    # Create a scene and display the faces
    scene2 = drawfaces(donutfaces, :black)
    setscene(scene2)
    getscene()
    sleep(1)
    
    # Perform a single subdivision step with the display callback
    catmullclark(donutfaces, 1, CatmullClark.displaycallback)

    face = donutfaces[2]

    # Test newedgepoint
    # The CatmullClark.newedgepoint function requires a valid Edge and the faces array
    # An isolated edge (like the one originally in the test case) will return the midpoint of the edge.
    @test CatmullClark.newedgepoint(CatmullClark.Edge(Point3f(100, 100, 100), Point3f(1, 1, 1)), donutfaces) == Point3f(50.5, 50.5, 50.5)

    # Test nexttohole
    edge = CatmullClark.Edge(face[1], face[2])
    @test !CatmullClark.nexttohole(edge, donutfaces)

    # Test adjacentpoints with a point not in the face
    @test_throws ErrorException CatmullClark.adjacentpoints(Point3f(100, 100, 100), donutfaces[1])

    # Test edgesforface and edgemidpoint
    f = CatmullClark.edgesforface(face)[1]
    @test f.p1[3] == 2.0
    @test CatmullClark.edgemidpoint(f)[1] == 0.0
end