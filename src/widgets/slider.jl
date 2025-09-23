export Slider

mutable struct Slider <: AttrapeComponent
    const value::MayBeReactive{Any}
    const min::Real
    const max::Real
    const step::Real
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Margin, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.Scale, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    signal_handler_id::Union{UInt, Nothing}
    function Slider(;
            value::MayBeReactive{Any},
            min::Real=0,
            max::Real=100,
            step::Real=1,
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Margin, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        return new(value, min, max, step, size, margin, expand, halign, valign, nothing, Catalyst(), Dict(), nothing)
    end
end

function mount!(s::Slider, ::AttrapeComponent)
    s.widget = Mousetrap.Scale()
    Mousetrap.set_range!(s.widget, s.min, s.max)
    Mousetrap.set_increments!(s.widget, s.step, s.step * 2)
    Mousetrap.set_value!(s.widget, resolve(s.value)::Real)

    if s.value isa AbstractReactive
        catalyze!(s.catalyst, s.value) do v
            s.dirty[:value] = v
            update!(s)
        end
        s.signal_handler_id = Mousetrap.connect_signal_value_changed!(s.widget) do _
            setvalue!(s.value, Mousetrap.get_value(s.widget))
            return
        end
    end

    apply_layout!(s, s.widget)

    return s.widget
end

function unmount!(s::Slider)
    inhibit!(s.catalyst)
    if !isnothing(s.signal_handler_id)
        Mousetrap.disconnect_signal!(s.widget, s.signal_handler_id)
        s.signal_handler_id = nothing
    end
    s.widget = nothing
end

function update!(s::Slider)
    isnothing(s.widget) && return
    for (dirt, val) in s.dirty
        if dirt == :value
            if Mousetrap.get_value(s.widget) != val
                Mousetrap.set_value!(s.widget, val::Real)
            end
        end
    end
    return
end
