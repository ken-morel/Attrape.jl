struct LabelBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{LabelBackend})::AttrapeMount
    println("Set child", isnothing(c.parent))
    label = Mousetrap.Label(c[:text]::String)
    c[:justify] isa Mousetrap.JustifyMode && Mousetrap.set_justify_mode!(label, c[:justify])
    c[:wrap] isa Mousetrap.LabelWrapMode && Mousetrap.set_wrap_mode!(label, c[:wrap])
    c[:ellipsize] isa Mousetrap.EllipsizeMode && Mousetrap.set_ellipsize_mode!(label, c[:ellipsize])
    processcommonargs!(c, label)
    c.mount = SimpleMount(label)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const Label = Efus.EfusTemplate(
    :Label,
    LabelBackend,
    Efus.TemplateParameter[
        :text! => String,
        :justify => Mousetrap.JustifyMode,
        :wrap => Mousetrap.LabelWrapMode,
        :ellipsize => Mousetrap.EllipsizeMode,
    ]
)
