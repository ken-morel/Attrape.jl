export Box

Base.@kwdef mutable struct Box <: AttrapeComponent
    const orient::Mousetrap.Orientation = OV
    const halign::Union{Mousetrap.Alignment, Nothing} = nothing
    const valign::Union{Mousetrap.Alignment, Nothing} = nothing
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Bool = false

    parent::Union{AttrapeComponent, Nothing} = nothing

    widget::Union{Mousetrap.Box, Nothing} = nothing


    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
    const children::Vector{<:AbstractComponent} = AttrapeComponent[]
end

function mount!(b::Box, p::AttrapeComponent)
    b.parent = p
    b.widget = Mousetrap.Box(b.orient)
    apply_layout!(b, b.widget)
    mountchildren!(b, b.widget)
    return b.widget
end
function unmount!(b::Box)
    unmount!.(b.children)
    b.parent = nothing
    b.widget = nothing
    Mousetrap.emit_signal_destroy(b.widget)
    return
end

function update!(::Box)
    return
end
