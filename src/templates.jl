include("templates/frame.jl")
include("templates/label.jl")
include("templates/box.jl")

function eregister()
    registertemplate(:Attrape, Frame)
    registertemplate(:Attrape, Label)
    registertemplate(:Attrape, Box)
    return
end
