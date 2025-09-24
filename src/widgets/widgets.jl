export getparent, shaketree

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

function getparent(c::AttrapeComponent)
    return if :parent ∈ fieldnames(typeof(c))
        c.parent
    end
end
function getchildren(c::AttrapeComponent)
    return if :children ∈ fieldnames(typeof(c))
        c.children
    end
end

function shaketree(c::AttrapeComponent; direction::Symbol = :top)
    # println("update ", string(typeof(c)), direction)
    update!(c)
    return if direction == :top
        p = getparent(c)
        if isnothing(p)
            shaketree(c; direction = :bottom)
        else
            shaketree(p; direction)
        end
    elseif direction == :bottom
        children = getchildren(c)
        !isnothing(children) && shaketree.(children; direction = :bottom)
    end
end
