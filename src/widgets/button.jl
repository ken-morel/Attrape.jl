export Button

Base.@kwdef mutable struct Button <: AttrapeComponent
    const text::MayBeReactive{String}
    onclick::Union{Function, Nothing} = nothing
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Mousetrap.Alignment, Nothing} = nothing
    const valign::Union{Mousetrap.Alignment, Nothing} = nothing

    parent::Union{AttrapeComponent, Nothing} = nothing
    widget::Union{Mousetrap.Button, Nothing} = nothing
    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(b::Button, p::AttrapeComponent)
    b.parent = p
    b.widget = Mousetrap.Button(Mousetrap.Label(resolve(AbstractString, b.text)))
    Mousetrap.connect_signal_clicked!(b.widget) do _
        !isnothing(b.onclick) && b.onclick(b)
        shaketree(b)
        return
    end

    b.text isa AbstractReactive && catalyze!(b.catalyst, b.text) do value
        b.dirty[:text] = value
    end

    apply_layout!(b, b.widget)
    return b.widget
end

function unmount!(b::Button)
    inhibit!(b.catalyst)
    b.parent = nothing
    b.widget = nothing
    Mousetrap.emit_signal_destroy(b.widget)
    return
end

function update!(b::Button)
    isnothing(b.widget) && return
    for (dirt, val) in b.dirty
        if dirt == :text
            Mousetrap.set_text!(b.widget, val::String)
        end
    end
    empty!(b.dirty)
    return
end
