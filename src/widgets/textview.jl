export TextView

mutable struct TextView <: AttrapeComponent
    const text::MayBeReactive{Any}
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Margin, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.TextView, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function TextView(
            text::MayBeReactive{Any},
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Margin, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        tv = new(text, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
        text isa AbstractReactive && catalyze!(tv.catalyst, text) do value
            tv.dirty[:text] = value
            update!(tv)
        end
        return tv
    end
end

function mount!(tv::TextView, ::AttrapeComponent)
    tv.widget = Mousetrap.TextView()
    buffer = Mousetrap.get_buffer(tv.widget)
    Mousetrap.set_text!(buffer, resolve(tv.text)::String)

    if tv.text isa AbstractReactive
        Mousetrap.connect_signal_changed!(buffer) do _
            setvalue!(tv.text, Mousetrap.get_text(buffer))
            return
        end
    end

    apply_layout!(tv, tv.widget)

    return tv.widget
end

function unmount!(tv::TextView)
    inhibit!(tv.catalyst)
end

function update!(tv::TextView)
    isnothing(tv.widget) && return
    for (dirt, val) in tv.dirty
        if dirt == :text
            buffer = Mousetrap.get_buffer(tv.widget)
            if Mousetrap.get_text(buffer) != val
                Mousetrap.set_text!(buffer, val::String)
            end
        end
    end
    return
end
