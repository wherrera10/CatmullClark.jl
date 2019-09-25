module CatmullClarkGraphics

export drawfaces, drawfaces!, displaycallback, getscene, setscene

using Makie, .CatmullClark

facewrapped(face) = [face; face[1]]
drawface(face, colr) = lines(facewrapped(face); color=colr)
drawface!(face, colr) = lines!(facewrapped(face); color=colr)
drawfaces!(faces, colr) = for f in faces drawface!(f, colr) end
const colors = [:red, :green, :blue, :gold]
const iterconfig = [0, length(colors), nothing]

setscene(s) = (iterconfig[3] = s)
getscene() = iterconfig[3]

function drawfaces(faces, colr)
    scene = drawface(faces[1], colr)
    if length(faces) > 1
        for f in faces[2:end]
            drawface!(f, colr)
        end
    end
    setscene(scene)
    return scene
end

function displaycallback(faces)
    drawfaces!(nextfaces, colors[iterconfig[1] % iterconfig[2] + 1])
    iterconfig[1] +=1
    iterconfig[3] != nothing && display(iterconfig[3])
    sleep(1)
end

end # module
