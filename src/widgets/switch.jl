export Switch

mutable struct Switch <: AttrapeComponent
    const active::MayBeReactive{Any}
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Margin, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.Switch, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    signal_handler_id::Union{UInt, Nothing}
    function Switch(;
            active::MayBeReactive{Any}=false,
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Margin, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        return new(active, size, margin, expand, halign, valign, nothing, Catalyst(), Dict(), nothing)
    end
end

function mount!(s::Switch, ::AttrapeComponent)
    s.widget = Mousetrap.Switch()
    Mousetrap.set_active!(s.widget, resolve(s.active)::Bool)

    if s.active isa AbstractReactive
        catalyze!(s.catalyst, s.active) do value
            s.dirty[:active] = value
            update!(s)
        end
        s.signal_handler_id = Mousetrap.connect_signal_state_set!(s.widget) do _, state
            setvalue!(s.active, state)
            return
        end
    end

    apply_layout!(s, s.widget)

    return s.widget
end

function unmount!(s::Switch)
    inhibit!(s.catalyst)
    if !isnothing(s.signal_handler_id)
        Mousetrap.disconnect_signal!(s.widget, s.signal_handler_id)
        s.signal_handler_id = nothing
    end
    s.widget = nothing
end

function update!(s::Switch)
    isnothing(s.widget) && return
    for (dirt, val) in s.dirty
        if dirt == :active
            if Mousetrap.get_active(s.widget) != val
                Mousetrap.set_active!(s.widget, val::Bool)
            end
        end
    end
    return
end
