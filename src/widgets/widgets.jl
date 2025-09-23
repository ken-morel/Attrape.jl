include("./frame.jl")
include("./box.jl")
include("./label.jl")
include("./button.jl")

function mountchildren!(c::AttrapeComponent, w::Any)
    for child in c.children
        Mousetrap.push_back!(w, mount!(child, c))
    end
    return
end
