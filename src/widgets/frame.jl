export Frame

Base.@kwdef mutable struct Frame <: AttrapeComponent
    const box::Union{Mousetrap.Orientation, Nothing} = nothing


    widget::Union{Mousetrap.Frame, Nothing} = nothing
    cbox::Union{Mousetrap.Box, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
    const children::Vector{<:AbstractComponent} = AttrapeComponent[]
end

function mount!(f::Frame, p::AttrapeComponent)
    f.parent = p
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

function unmount!(f::Frame)
    unmount!.(f.children)
    return
end

function update!(::Frame)
    empty!(s.dirty)
    return
end
