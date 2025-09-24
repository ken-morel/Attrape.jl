export Slider

Base.@kwdef mutable struct Slider <: AttrapeComponent
    const value::MayBeReactive{<:Real}
    const min::Real = 0
    const max::Real = 100
    const step::Real = 0.1
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Symbol, Nothing} = nothing
    const valign::Union{Symbol, Nothing} = nothing

    widget::Union{Mousetrap.Scale, Nothing} = nothing
    signal_handler_id::Union{UInt, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(s::Slider, p::AttrapeComponent)
    s.parent = p
    s.widget = Mousetrap.Scale()
    Mousetrap.set_range!(s.widget, s.min, s.max)
    Mousetrap.set_increments!(s.widget, s.step, s.step * 2)
    Mousetrap.set_value!(s.widget, resolve(s.value)::Real)

    if s.value isa AbstractReactive
        catalyze!(s.catalyst, s.value) do v
            s.dirty[:value] = v
            shaketree(s)
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
    s.parent = nothing
    s.widget = nothing
    return
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
    empty!(s.dirty)
    return
end
