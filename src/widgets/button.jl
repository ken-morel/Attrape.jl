export Button

mutable struct Button <: AttrapeComponent
    const text::MayBeReactive{Any}
    const onclick::Function
    widget::Union{Mousetrap.Button, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function Button(; text::MayBeReactive{Any}, onclick::Function)
        btn = new(text, onclick, nothing, Catalyst(), Dict())
        text isa AbstractReactive && catalyze!(btn.catalyst, text) do value
            btn.dirty[:text] = value
            update!(btn) #FIX: Delayed updates
        end
        return btn
    end
end

function mount!(b::Button, ::AttrapeComponent)
    b.widget = Mousetrap.Button(Mousetrap.Label(resolve(b.text)::String))
    Mousetrap.connect_signal_clicked!(b.widget) do _
        b.onclick(b)
        return
    end
    return b.widget
end

function update!(b::Button)
    isnothing(b.widget) && return
    for (dirt, val) in b.dirty
        if dirt == :text
            Mousetrap.set_text!(b.widget, val::String)
        end
    end
    return
end
