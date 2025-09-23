export Label

Base.@kwdef mutable struct Label <: AttrapeComponent
    text::String
    widget::Union{Mousetrap.Label, Nothing} = nothing
end

function mount!(l::Label, p::AttrapeComponent)
    l.widget = Mousetrap.Label(l.text)
    return l.widget
end
