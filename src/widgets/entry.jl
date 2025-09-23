export Entry

mutable struct Entry <: AttrapeComponent
    const text::MayBeReactive{Any}
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Margin, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.Entry, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function Entry(;
            text::MayBeReactive{Any},
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Margin, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        entry = new(text, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
        text isa AbstractReactive && catalyze!(entry.catalyst, text) do value
            entry.dirty[:text] = value
            update!(entry)
        end
        return entry
    end
end

function mount!(e::Entry, ::AttrapeComponent)
    e.widget = Mousetrap.Entry()
    Mousetrap.set_text!(e.widget, resolve(e.text)::String)

    if e.text isa AbstractReactive
        Mousetrap.connect_signal_changed!(e.widget) do _
            setvalue!(e.text, Mousetrap.get_text(e.widget))
            return
        end
    end

    apply_layout!(e, e.widget)

    return e.widget
end

function unmount!(e::Entry)
    inhibit!(e.catalyst)
end

function update!(e::Entry)
    isnothing(e.widget) && return
    for (dirt, val) in e.dirty
        if dirt == :text
            if Mousetrap.get_text(e.widget) != val
                Mousetrap.set_text!(e.widget, val::String)
            end
        end
    end
    return
end
