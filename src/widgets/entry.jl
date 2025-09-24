export Entry

Base.@kwdef mutable struct Entry <: AttrapeComponent
    const text::MayBeReactive{String}
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Symbol, Nothing} = nothing
    const valign::Union{Symbol, Nothing} = nothing

    parent::Union{AttrapeComponent, Nothing} = nothing

    widget::Union{Mousetrap.Entry, Nothing} = nothing
    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
    signal_handler_id::Union{UInt, Nothing} = nothing
end

function mount!(e::Entry, p::AttrapeComponent)
    e.parent = p
    e.widget = Mousetrap.Entry()
    Mousetrap.set_text!(e.widget, resolve(AbstractString, e.text))

    if e.text isa AbstractReactive
        catalyze!(e.catalyst, e.text) do value
            e.dirty[:text] = value
            shaketree(b)
        end
        e.signal_handler_id = Mousetrap.connect_signal_changed!(e.widget) do _
            setvalue!(e.text, Mousetrap.get_text(e.widget))

            return
        end
    end

    apply_layout!(e, e.widget)

    return e.widget
end

function unmount!(e::Entry)
    e.parent = nothing
    inhibit!(e.catalyst)
    if !isnothing(e.signal_handler_id)
        Mousetrap.disconnect_signal!(e.widget, e.signal_handler_id)
        e.signal_handler_id = nothing
    end
    e.widget = nothing
    return
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
    empty!(s.dirty)
    return
end
