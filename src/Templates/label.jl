struct LabelBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{LabelBackend})::AttrapeMount
    label = Mousetrap.Label(c[:text]::String)
    c[:justify] isa JustifyMode && set_justify_mode!(label, c[:justify])
    c[:wrap] isa LabelWrapMode && set_wrap_mode!(label, c[:wrap])
    c[:ellipsize] isa EllipsizeMode && set_ellipsize_mode!(label, c[:ellipsize])
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
        :justify => JustifyMode,
        :wrap => LabelWrapMode,
        :ellipsize => EllipsizeMode,
    ]
)
