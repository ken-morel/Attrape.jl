export TextView

Base.@kwdef mutable struct TextView <: AttrapeComponent
    const text::MayBeReactive{String}
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Mousetrap.Alignment, Nothing} = nothing
    const valign::Union{Mousetrap.Alignment, Nothing} = nothing

    widget::Union{Mousetrap.TextView, Nothing} = nothing
    signal_handler_id::Union{UInt, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(tv::TextView, p::AttrapeComponent)
    tv.parent = p
    tv.widget = Mousetrap.TextView()
    Mousetrap.set_text!(tv.widget, resolve(String, tv.text))

    if tv.text isa AbstractReactive
        catalyze!(tv.catalyst, tv.text) do value
            tv.dirty[:text] = value
            shaketree(tv)
        end
        tv.signal_handler_id = Mousetrap.connect_signal_text_changed!(tv.widget) do _
            setvalue!(tv.text, Mousetrap.get_text(tv.widget))
            return
        end
    end

    apply_layout!(tv, tv.widget)

    return tv.widget
end

function unmount!(tv::TextView)
    tv.parent = nothing
    inhibit!(tv.catalyst)
    if !isnothing(tv.signal_handler_id)
        Mousetrap.disconnect_signal_text_changed!(tv.widget)
        tv.signal_handler_id = nothing
    end
    tv.widget = nothing
    Mousetrap.emit_signal_destroy(tv.widget)
    return
end

function update!(tv::TextView)
    isnothing(tv.widget) && return
    for (dirt, val) in tv.dirty
        if dirt == :text
            if Mousetrap.get_text(tv.widget) != val
                Mousetrap.set_text!(tv.widget, val::String)
            end
        end
    end
    empty!(tv.dirty)
    return
end
