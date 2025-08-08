include("templates/frame.jl")
include("templates/label.jl")
include("templates/box.jl")
include("templates/flowbox.jl")

function eregister()
    registertemplate(:Attrape, Frame)
    registertemplate(:Attrape, Label)
    registertemplate(:Attrape, Box)
    registertemplate(:Attrape, FlowBox)
    return
end
