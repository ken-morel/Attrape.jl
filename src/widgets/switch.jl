export Switch

Base.@kwdef mutable struct Switch <: AttrapeComponent
    const active::MayBeReactive{Bool}
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Symbol, Nothing} = nothing
    const valign::Union{Symbol, Nothing} = nothing

    widget::Union{Mousetrap.Switch, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing
    signal_handler_id::Union{UInt, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(s::Switch, p::AttrapeComponent)
    s.parent = p
    s.widget = Mousetrap.Switch()
    Mousetrap.set_is_active!(s.widget, resolve(s.active)::Bool)

    if s.active isa AbstractReactive
        catalyze!(s.catalyst, s.active) do value
            s.dirty[:active] = value
            update!(s)
        end
        s.signal_handler_id = Mousetrap.connect_signal_switched!(s.widget) do state
            setvalue!(s.active, state)
            return
        end
    end

    apply_layout!(s, s.widget)

    return s.widget
end

function unmount!(s::Switch)
    s.parent = nothing
    inhibit!(s.catalyst)
    if !isnothing(s.signal_handler_id)
        Mousetrap.disconnect_signal_switched!(s.widget)
        s.signal_handler_id = nothing
    end
    s.widget = nothing
    Mousetrap.emit_signal_destroy(s.widget)
    return
end

function update!(s::Switch)
    isnothing(s.widget) && return
    for (dirt, val) in s.dirty
        if dirt == :active
            if Mousetrap.get_is_active(s.widget) != val
                Mousetrap.set_is_active!(s.widget, val::Bool)
            end
        end
    end
    empty!(s.dirty)
    return
end
