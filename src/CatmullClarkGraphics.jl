module CatmullClarkGraphics

export drawfaces, drawfaces!, displaycallback

using Makie, .CatmullClark

facewrapped(face) = begin f = deepcopy(face); push!(f, f[1]); f end
drawface(face, colr) = lines(facewrapped(face); color=colr)
drawface!(face, colr) = lines!(facewrapped(face); color=colr)
drawfaces!(faces, colr) = for f in faces drawface!(f, colr) end
const colors = [:red, :green, :blue, :gold]
const iterconfig = [0, length(colors), nothing]

function drawfaces(faces, colr)
    scene = drawface(faces[1], colr)
    if length(faces) > 1
        for f in faces[2:end]
            drawface!(f, colr)
        end
    end
    iterconfig[3] = scene
    return scene
end

function displaycallback(faces)
    drawfaces!(nextfaces, colors[iterconfig[1] % iterconfig[2] + 1])
    iterconfig[1] +=1
    iterconfig[3] != nothing && display(iterconfig[3])
    sleep(1)
end

end # module
