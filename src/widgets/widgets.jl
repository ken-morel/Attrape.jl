include("./layout.jl")
include("./frame.jl")
include("./box.jl")
include("./label.jl")
include("./button.jl")
include("./textview.jl")
include("./entry.jl")
include("./picture.jl")
include("./spinner.jl")
include("./switch.jl")
include("./slider.jl")
include("./progressbar.jl")

function mountchildren!(c::AttrapeComponent, w::Any)
    for child in c.children
        Mousetrap.push_back!(w, mount!(child, c))
    end
    return
end
