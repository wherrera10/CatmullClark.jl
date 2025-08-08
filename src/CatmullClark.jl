module CatmullClark

export catmullclarkstep, catmullclark

export drawfaces, drawfaces!, displaycallback, getscene, setscene

using Makie, GeometryBasics, Statistics, ThreadSafeDicts

# Point3f is the modern type for a 3-tuple of 32-bit floats.
# A Face is defined by the points that are its vertices.
Face = Vector{Point3f}

# An Edge is a line segment, with points sorted for canonical representation.
struct Edge
    p1::Point3f
    p2::Point3f
    Edge(a, b) = new(min(a, b), max(a, b))
end

edgemidpoint(edge) = (edge.p1 + edge.p2) / 2.0
facesforpoint(p, faces) = [f for f in faces if p in f]
facesforedge(e, faces) = [f for f in faces if (e.p1 in f) && (e.p2 in f)]
nexttohole(edge, faces) = length(facesforedge(edge, faces)) < 2

function newedgepoint(edge, faces)
    f = facesforedge(edge, faces)
    p1, p2, len = edge.p1, edge.p2, length(f)
    if len == 2
        return (p1 + p2 + mean(f[1]) + mean(f[2])) / 4.0
    elseif len == 1
        return (p1 + p2 + mean(f[1])) / 3.0
    end
    return (p1 + p2) / 2.0
end

function edgesforface(face)
    len = length(face)
    indices = [1:len; 1]
    return [Edge(face[indices[i]], face[indices[i+1]]) for i in 1:len]
end

function edgesforpoint(p, faces)
    f = filter(x -> p in x, faces)
    return filter(e -> p == e.p1 || p == e.p2, mapreduce(edgesforface, vcat, f))
end

function adjacentpoints(point, face)
    a_idx = findfirst(isequal(point), face)
    if a_idx === nothing
        throw(ErrorException("point $point not in face $face"))
    end
    len = length(face)

    prev_idx = mod1(a_idx - 1, len)
    next_idx = mod1(a_idx + 1, len)

    return sort([face[prev_idx], face[next_idx]])
end

adjacentedges(point, face) = [Edge(point, x) for x in adjacentpoints(point, face)]

"""
    catmullclarkstep(faces)

Perform a single step of Catmull-Clark subdivision of a surface.
The faces argument is a `Vector{Face}` of all the faces of the 3D object's surface.
Returns: a `Vector` of the new faces.
"""
function catmullclarkstep(faces)
    d = Set(reduce(vcat, faces))
    E = ThreadSafeDict{Tuple{Edge, Face}, Point3f}()
    facepoints = ThreadSafeDict{Face, Point3f}()
    dprime = ThreadSafeDict{Point3f, Point3f}()

    Threads.@threads for face in faces
        facepoints[face] = mean(face)
        for (i, p) in enumerate(face)
            edge = (p == face[end]) ? Edge(p, face[1]) : Edge(p, face[i+1])
            E[(edge, face)] = newedgepoint(edge, faces)
        end
    end

    dvec = collect(d)  # Convert Set to Vector for threading
    Threads.@threads for p in dvec
        faceswithp = facesforpoint(p, faces)
        F = mean([facepoints[face] for face in faceswithp])
        pe = edgesforpoint(p, faces)
        R = mean(map(edgemidpoint, pe))
        n = length(pe)
        dprime[p] = (F + 2 * R + p * (n - 3)) / n
    end

    tasks = map(faces) do face
        Threads.@spawn begin
            tasknewfaces = Face[]
            vertex = facepoints[face]
            for point in face
                adjacent = adjacentedges(point, face)
                fp1 = E[(adjacent[1], face)]
                fp2 = E[(adjacent[2], face)]
                push!(tasknewfaces, [fp1, dprime[point], fp2, vertex])
            end
            tasknewfaces
        end
    end
    newfaces = Face[]
    for task in tasks
        append!(newfaces, fetch(task))
    end

    return newfaces
end

"""
    catmullclark(faces, iters, callback=(x)->nothing)

Perform a multistep Catmull-Clark subdivision of a surface.
Does `iters` iterations (steps). Will call a callback function
with the results of each iteration (step) if one is provided.
Returns: the faces of the final result.
"""
function catmullclark(faces, iters, callback = (x)->nothing)
    nextfaces = deepcopy(faces)
    for _ in 1:iters
        nextfaces = catmullclarkstep(nextfaces)
        callback(nextfaces)
    end
    return nextfaces
end

# The following functions are used in graphics display with Makie.

facewrapped(face) = (f = deepcopy(face); push!(f, f[1]); f)
drawface(face, colr) = lines(facewrapped(face); color = colr)
drawface!(face, colr) = lines!(facewrapped(face); color = colr)

"""
    drawfaces!(faces, colr)
Draw a set of Faces using color colr and Makie.
Add the drawing to the existing scene.
"""
drawfaces!(faces, colr) =
    for f in faces
        drawface!(f, colr)
    end

"""
    drawfaces(faces, colr)
Draw a set of Faces using color colr and Makie.
Place this in a new scene (a new output window).
"""
function drawfaces(faces, colr)
    fig = Figure()
    ax = Axis3(fig[1, 1])

    Makie.with_updates_suspended(fig.layout) do
        for f in faces
            lines!(ax, facewrapped(f); color = colr)
        end
    end

    return ax.scene
end

const colors = [:red, :green, :blue, :gold]
const iterconfig = Ref((0, length(colors), Scene()))

"""
    setscene(scene)
Set the Scene for display using Makie.
"""
setscene(s) = iterconfig[] = (iterconfig[][1], iterconfig[][2], s)

"""
    getscene()
Get the Makie.jl Scene in use for display by the package.
"""
getscene() = iterconfig[][3]

"""
    displaycallback(faces)

Display a set of Faces using Makie. This can be used as a
callback to show the steps of the catmullclark function.
"""
function displaycallback(faces)
    idx, num_colors, scene = iterconfig[]
    drawfaces!(faces, colors[idx%num_colors+1])
    iterconfig[] = (idx + 1, num_colors, scene)

    sleep(1)
end

end # module
