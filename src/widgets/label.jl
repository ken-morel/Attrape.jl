export Label

mutable struct Label <: AttrapeComponent
    const text::MayBeReactive{Any}
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Size, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.Label, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function Label(;
            text::MayBeReactive{Any},
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Size, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        return new(text, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
    end
end

function mount!(l::Label, ::AttrapeComponent)
    l.widget = Mousetrap.Label(resolve(l.text)::String)

    l.text isa AbstractReactive && catalyze!(l.catalyst, l.text) do value
        l.dirty[:text] = value
        update!(l)
    end

    apply_layout!(l, l.widget)

    return l.widget
end

function unmount!(l::Label)
    inhibit!(l.catalyst)
    l.widget = nothing
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
