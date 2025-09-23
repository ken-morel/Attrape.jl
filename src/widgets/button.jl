export Button

mutable struct Button <: AttrapeComponent
    const text::MayBeReactive{Any}
    const onclick::Function
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Margin, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.Button, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function Button(;
            text::MayBeReactive{Any},
            onclick::Function,
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Margin, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        btn = new(text, onclick, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
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

    apply_layout!(b, b.widget)

    return b.widget
end

function unmount!(b::Button)
    inhibit!(b.catalyst)
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
