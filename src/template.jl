abstract type AttrapeBackend <: Efus.TemplateBackend end
abstract type AttrapeMount <: Efus.AbstractMount end

const AttrapeComponent = Efus.Component{<:AttrapeBackend}

struct SimpleMount <: AttrapeMount
    widget::Mousetrap.Widget
    outlet::Mousetrap.Widget
    SimpleMount(w::Mousetrap.Widget) = new(w, w)
    SimpleMount(w::Mousetrap.Widget, o::Mousetrap.Widget) = new(w, o)
end

@enum _UpdateSide _UpdateSideNone _UpdateSideMousetrap _UpdateSideAttrape
mutable struct SimpleSyncingMount <: AttrapeMount
    const widget::Mousetrap.Widget
    const outlet::Mousetrap.Widget
    updateside::_UpdateSide
    SimpleSyncingMount(w::Mousetrap.Widget) = new(w, w, _UpdateSideNone)
    SimpleSyncingMount(w::Mousetrap.Widget, o::Mousetrap.Widget) = new(w, o, _UpdateSideNone)
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

function errorincallback(e::Exception)
    printstyled(stderr, "[ERROR] "; bold = true, color = :red)
    printstyled(stderr, "In Attrape callback: "; bold = true)
    Base.showerror(stderr, e, catch_backtrace())
    return print(stderr, "\n")

end
