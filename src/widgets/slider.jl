export Slider

const SliderRange = StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}

Base.@kwdef mutable struct Slider <: AttrapeComponent
    const value::MayBeReactive{Float32}
    const range::MayBeReactive{SliderRange} = 0.0:100.0
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Mousetrap.Alignment, Nothing} = nothing
    const valign::Union{Mousetrap.Alignment, Nothing} = nothing

    widget::Union{Mousetrap.Scale, Nothing} = nothing
    signal_handler_id::Union{UInt, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function setbounds!(c::Slider, s::Mousetrap.Scale)
    range = resolve(SliderRange, c.range)
    Mousetrap.set_upper!(s, last(range))
    Mousetrap.set_lower!(s, first(range))
    Mousetrap.set_step_increment!(s, last(range))
    return
end
function mount!(s::Slider, p::AttrapeComponent)
    s.parent = p
    range = resolve(SliderRange, s.range)
    s.widget = Mousetrap.Scale(first(range), last(range), step(range))
    setbounds!(s, s.widget)
    Mousetrap.set_value!(s.widget, Float32(resolve(Real, s.value)))
    if s.value isa AbstractReactive
        catalyze!(s.catalyst, s.value) do v
            s.dirty[:value] = v
            shaketree(s)
        end
        s.signal_handler_id = Mousetrap.connect_signal_value_changed!(s.widget) do w
            if s.value isa AbstractReactive
                setvalue!(s.value, Mousetrap.get_value(s.widget))
            end
            return
        end
    end
    if s.range isa AbstractReactive
        catalyze!(s.catalyst, s.range) do v
            s.dirty[:range] = v
            shaketree(s)
        end
    end

    apply_layout!(s, s.widget)

    return s.widget
end

function unmount!(s::Slider)
    inhibit!(s.catalyst)
    if !isnothing(s.signal_handler_id)
        Mousetrap.disconnect_signal_value_changed!(s.widget)
        s.signal_handler_id = nothing
    end
    s.parent = nothing
    s.widget = nothing
    Mousetrap.emit_signal_destroy(s.widget)
    return
end

function update!(s::Slider)
    isnothing(s.widget) && return
    for (dirt, val) in s.dirty
        if dirt == :value
            if Mousetrap.get_value(s.widget) != val
                Mousetrap.set_value!(s.widget, val::Real)
            end
        elseif dirt == :range
            setbounds!(s, s.widget)
        end
    end
    empty!(s.dirty)
    return
end
