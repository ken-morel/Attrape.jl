export Spinner

Base.@kwdef mutable struct Spinner <: AttrapeComponent
    const active::MayBeReactive{Bool} = true
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Symbol, Nothing} = nothing
    const valign::Union{Symbol, Nothing} = nothing

    widget::Union{Mousetrap.Spinner, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(s::Spinner, p::AttrapeComponent)
    s.parent = p
    s.widget = Mousetrap.Spinner()
    if resolve(Bool, s.active)
        Mousetrap.start!(s.widget)
    end

    s.active isa AbstractReactive && catalyze!(s.catalyst, s.active) do value
        s.dirty[:active] = value
        shaketree(s)
    end

    apply_layout!(s, s.widget)

    return s.widget
end

function unmount!(s::Spinner)
    inhibit!(s.catalyst)
    s.parent = nothing
    s.widget = nothing
    Mousetrap.emit_signal_destroy(s.widget)
    return
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
    empty!(s.dirty)
    return
end
