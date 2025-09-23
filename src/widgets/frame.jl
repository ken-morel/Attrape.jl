export Frame

mutable struct Frame <: AttrapeComponent
    const box::Union{Mousetrap.Orientation, Nothing}
    widget::Union{Mousetrap.Frame, Nothing}
    cbox::Union{Mousetrap.Box, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    const children::Vector{<:AbstractComponent}
    function Frame(; children::Vector{<:AbstractComponent}, box::Union{Mousetrap.Orientation, Nothing})
        return new(box, nothing, nothing, Catalyst(), Dict(), children)
    end
end

function mount!(f::Frame, ::AttrapeComponent)
    f.widget = Mousetrap.Frame()
    if !isnothing(f.box)
        f.cbox = Mousetrap.Box(f.box)
        Mousetrap.set_child!(f.widget, f.cbox)
        mountchildren!(f, f.cbox)
    else
        if length(f.children) > 0
            child = mount!(f.children[1], f)
            Mousetrap.set_child!(f.widget, child)
        end
    end

    return f.widget
end

function update!(::Frame)
    return
end
