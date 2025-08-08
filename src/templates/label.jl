struct LabelBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{LabelBackend})::AttrapeMount
    println("Set child", isnothing(c.parent))
    label = Mousetrap.Label(something(c[:text], ":-("))
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
    ]
)
