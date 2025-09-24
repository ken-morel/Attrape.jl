export Label

Base.@kwdef mutable struct Label <: AttrapeComponent
    const text::MayBeReactive{AbstractString}
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Symbol, Nothing} = nothing
    const valign::Union{Symbol, Nothing} = nothing

    widget::Union{Mousetrap.Label, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(l::Label, p::AttrapeComponent)
    l.parent = p
    l.widget = Mousetrap.Label(resolve(AbstractString, l.text))

    l.text isa AbstractReactive && catalyze!(l.catalyst, l.text) do value
        l.dirty[:text] = value
        shaketree(l)
    end

    apply_layout!(l, l.widget)

    return l.widget
end

function unmount!(l::Label)
    inhibit!(l.catalyst)
    l.parent = nothing
    l.widget = nothing
    return
end

function update!(l::Label)
    isnothing(l.widget) && return
    for (dirt, val) in l.dirty
        if dirt == :text
            Mousetrap.set_text!(l.widget, val::String)
        end
    end
    return
end
