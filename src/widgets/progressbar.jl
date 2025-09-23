export ProgressBar

mutable struct ProgressBar <: AttrapeComponent
    const fraction::MayBeReactive{Any}
    const size::Union{Efus.Size, Nothing}
    const margin::Union{Efus.Margin, Nothing}
    const expand::Union{Bool, Nothing}
    const halign::Union{Symbol, Nothing}
    const valign::Union{Symbol, Nothing}
    widget::Union{Mousetrap.ProgressBar, Nothing}
    const catalyst::Catalyst
    const dirty::Dict{Symbol, Any}
    function ProgressBar(;
            fraction::MayBeReactive{Any}=0.0,
            size::Union{Efus.Size, Nothing}=nothing,
            margin::Union{Efus.Margin, Nothing}=nothing,
            expand::Union{Bool, Nothing}=nothing,
            halign::Union{Symbol, Nothing}=nothing,
            valign::Union{Symbol, Nothing}=nothing
        )
        pb = new(fraction, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
        fraction isa AbstractReactive && catalyze!(pb.catalyst, fraction) do value
            pb.dirty[:fraction] = value
            update!(pb)
        end
        return pb
    end
end

function mount!(pb::ProgressBar, ::AttrapeComponent)
    pb.widget = Mousetrap.ProgressBar()
    Mousetrap.set_fraction!(pb.widget, resolve(pb.fraction)::Real)

    apply_layout!(pb, pb.widget)

    return pb.widget
end

function unmount!(pb::ProgressBar)
    inhibit!(pb.catalyst)
end

function update!(pb::ProgressBar)
    isnothing(pb.widget) && return
    for (dirt, val) in pb.dirty
        if dirt == :fraction
            Mousetrap.set_fraction!(pb.widget, val::Real)
        end
    end
    return
end
