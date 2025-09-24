export Button

Base.@kwdef mutable struct Button <: AttrapeComponent
    const text::MayBeReactive{AbstractString}
    const onclick::Function
    const size::Union{Efus.Size, Nothing} = nothing
    const margin::Union{Efus.Size, Nothing} = nothing
    const expand::Union{Bool, Nothing} = nothing
    const halign::Union{Symbol, Nothing} = nothing
    const valign::Union{Symbol, Nothing} = nothing

    parent::Union{AttrapeComponent, Nothing} = nothing
    widget::Union{Mousetrap.Button, Nothing} = nothing
    const catalyst::Catalyst = Catalyst()
    const dirty::Dict{Symbol, Any} = Dict()
end

function mount!(b::Button, p::AttrapeComponent)
    b.parent = p
    b.widget = Mousetrap.Button(Mousetrap.Label(resolve(AbstractString, b.text)))
    Mousetrap.connect_signal_clicked!(b.widget) do _
        b.onclick(b)
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
    return
end

function update!(b::Button)
    isnothing(b.widget) && return
    for (dirt, val) in b.dirty
        if dirt == :text
            Mousetrap.set_text!(b.widget, val::String)
        end
    end
    empty!(s.dirty)
    return
end
