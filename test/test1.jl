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

const faces = [map(x -> Point3f0(inputpoints[x]), p .+ 1) for p in inputfaces]

@test faces[3][4] == [1.0, 1.0, 1.0]

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

dfaces = [map(x -> Point3f0(donutpoints[x + 1]), p) for p in donutfaceindices]

@test dfaces[1][1] == [-1.0, -0.5, -1.0]

# test cube
newfaces = catmullclark(faces, 2)

@test newfaces[1][2][1] ≈ -0.71744794
@test newfaces[1][2][3] ≈ 0.0

# test torus
newfaces = catmullclark(dfaces, 1)

@test newfaces[2][3][1] == -1.125
@test newfaces[2][3][3] == 0.0

# test with hole
newfaces = catmullclark(faces[2:end], 2)

@test newfaces[1][2][1] == 0.9375
@test newfaces[1][2][2] ≈ -0.46875003
@test newfaces[1][2][3] == 0.0
