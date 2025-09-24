export TextView

Base.@kwdef mutable struct TextView <: AttrapeComponent
    const text::MayBeReactive{String}
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Symbol, Nothing} = nothing
    const valign::Union{Symbol, Nothing} = nothing

    widget::Union{Mousetrap.TextView, Nothing} = nothing
    signal_handler_id::Union{UInt, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(tv::TextView, p::AttrapeComponent)
    tv.parent = p
    tv.widget = Mousetrap.TextView()
    buffer = Mousetrap.get_buffer(tv.widget)
    Mousetrap.set_text!(buffer, resolve(tv.text)::String)

    if tv.text isa AbstractReactive
        catalyze!(tv.catalyst, tv.text) do value
            tv.dirty[:text] = value
            shaketree(tv)
        end
        tv.signal_handler_id = Mousetrap.connect_signal_changed!(buffer) do _
            setvalue!(tv.text, Mousetrap.get_text(buffer))
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
        Mousetrap.disconnect_signal!(tv.widget, tv.signal_handler_id)
        tv.signal_handler_id = nothing
    end
    tv.widget = nothing
    return
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
    empty!(tv.dirty)
    return
end
