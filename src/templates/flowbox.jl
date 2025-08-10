struct FlowBoxBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{FlowBoxBackend})::AttrapeMount
    box = Mousetrap.FlowBox(something(c[:orient], Mousetrap.ORIENTATION_VERTICAL))
    processcommonargs!(c, box)
    c[:spacing] isa Integer && Mousetrap.set_spacing!(box, c[:spacing])
    c.mount = SimpleMount(box)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end


const FlowBox = Efus.EfusTemplate(
    :FlowBox,
    FlowBoxBackend,
    Efus.TemplateParameter[
        :orient! => Mousetrap.detail._Orientation,
        :spacing => Integer,
    ]
)
