abstract type AttrapeTemplate <: Efus.AbstractTemplate end
abstract type AttrapeBackend <: Efus.TemplateBackend end
abstract type AttrapeMount <: Efus.AbstractMount end

struct SimpleMount <: AttrapeMount
    widget::Mousetrap.Widget
end
