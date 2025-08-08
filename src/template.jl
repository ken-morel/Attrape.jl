abstract type AttrapeBackend <: Efus.TemplateBackend end
abstract type AttrapeMount <: Efus.AbstractMount end

const AttrapeComponent = Efus.Component{<:AttrapeBackend}

struct SimpleMount <: AttrapeMount
    widget::Mousetrap.Widget
    outlet::Mousetrap.Widget
    SimpleMount(w::Mousetrap.Widget) = new(w, w)
    SimpleMount(w::Mousetrap.Widget, o::Mousetrap.Widget) = new(w, o)
end

const COMMON_ARGS = []

function processcommonargs!(::AttrapeComponent, ::Mousetrap.Widget)
end

function childgeometry!(parent::AttrapeComponent, child::AttrapeComponent)
    isnothing(parent.mount) && return
    isnothing(child.mount) && return
    Mousetrap.push_back!(parent.mount.widget, child.mount.widget)
    return
end
