export Spinner

mutable struct Spinner <: AttrapeComponent
    const active::MayBeReactive{Any}
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Size, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.Spinner, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function Spinner(;
            active::MayBeReactive{Any}=true,
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Size, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        return new(active, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
    end
end

function mount!(s::Spinner, ::AttrapeComponent)
    s.widget = Mousetrap.Spinner()
    if resolve(s.active)::Bool
        Mousetrap.start!(s.widget)
    end

    s.active isa AbstractReactive && catalyze!(s.catalyst, s.active) do value
        s.dirty[:active] = value
        update!(s)
    end

    apply_layout!(s, s.widget)

    return s.widget
end

function unmount!(s::Spinner)
    inhibit!(s.catalyst)
    s.widget = nothing
end

function update!(s::Spinner)
    isnothing(s.widget) && return
    for (dirt, val) in s.dirty
        if dirt == :active
            if val::Bool
                Mousetrap.start!(s.widget)
            else
                Mousetrap.stop!(s.widget)
            end
        end
    end
    return
end
