export Box

mutable struct Box <: AttrapeComponent
    const orient::Mousetrap.Orientation
    widget::Union{Mousetrap.Box, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    const children::Vector{<:AbstractComponent}
    function Box(;
            orient::Mousetrap.Orientation = V,
            margin::Union{Efus.Size, Nothing} = nothing,
            expand::Bool = false,
            children::Vector{<:AbstractComponent} = [],
            halign::Union{Symbol, Nothing} = nothing,
            valign::Union{Symbol, Nothing} = nothing,
            size::Union{Efus.Size, Nothing} = nothing,
        )
        return new(orient, nothing, Catalyst(), Dict(), children)
    end
end

function mount!(b::Box, ::AttrapeComponent)
    b.widget = Mousetrap.Box(b.orient)
    mountchildren!(b, b.widget)
    return b.widget
end

function update!(::Box)
    return
end
