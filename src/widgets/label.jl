export Label

mutable struct Label <: AttrapeComponent
    const text::MayBeReactive{Any}
    widget::Union{Mousetrap.Label, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function Label(; text::MayBeReactive{Any})
        lbl = new(text, nothing, Catalyst(), Dict())
        text isa AbstractReactive && catalyze!(lbl.catalyst, text) do value
            lbl.dirty[:text] = value
            update!(lbl) #FIX: Delayed updates
        end
        return lbl
    end
end

function mount!(l::Label, ::AttrapeComponent)
    l.widget = Mousetrap.Label(resolve(l.text)::String)
    return l.widget
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
