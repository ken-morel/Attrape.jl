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
    function Switch(;
            active::MayBeReactive{Any}=false,
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Margin, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        s = new(active, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
        active isa AbstractReactive && catalyze!(s.catalyst, active) do value
            s.dirty[:active] = value
            update!(s)
        end
        return s
    end
end

function mount!(s::Switch, ::AttrapeComponent)
    s.widget = Mousetrap.Switch()
    Mousetrap.set_active!(s.widget, resolve(s.active)::Bool)

    if s.active isa AbstractReactive
        Mousetrap.connect_signal_state_set!(s.widget) do _, state
            setvalue!(s.active, state)
            return
        end
    end

    apply_layout!(s, s.widget)

    return s.widget
end

function unmount!(s::Switch)
    inhibit!(s.catalyst)
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
