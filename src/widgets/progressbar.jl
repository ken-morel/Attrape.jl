export ProgressBar

Base.@kwdef mutable struct ProgressBar <: AttrapeComponent
    const fraction::MayBeReactive{Float64}
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Mousetrap.Alignment, Nothing} = nothing
    const valign::Union{Mousetrap.Alignment, Nothing} = nothing

    widget::Union{Mousetrap.ProgressBar, Nothing} = nothing
    parent::Union{AttrapeComponent, Nothing} = nothing

    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(pb::ProgressBar, p::AttrapeComponent)
    pb.parent = p
    pb.widget = Mousetrap.ProgressBar()
    Mousetrap.set_fraction!(pb.widget, resolve(pb.fraction)::Real)

    pb.fraction isa AbstractReactive && catalyze!(pb.catalyst, pb.fraction) do value
        pb.dirty[:fraction] = value
        shaketree(pb)
    end

    apply_layout!(pb, pb.widget)

    return pb.widget
end

function unmount!(pb::ProgressBar)
    inhibit!(pb.catalyst)
    pb.widget = nothing
    pb.parent = nothing
    Mousetrap.emit_signal_destroy(pb.widget)
    return
end

function update!(pb::ProgressBar)
    isnothing(pb.widget) && return
    for (dirt, val) in pb.dirty
        if dirt == :fraction
            Mousetrap.set_fraction!(pb.widget, val::Real)
        end
    end
    empty!(pb.dirty)
    return
end
