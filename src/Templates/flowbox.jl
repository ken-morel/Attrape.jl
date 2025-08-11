struct FlowBoxBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{FlowBoxBackend})::AttrapeMount
    box = Mousetrap.FlowBox(c[:orient]::Mousetrap.detail._Orientation)
    processcommonargs!(c, box)
    c[:spacing] isa Integer && set_spacing!(box, c[:spacing])
    c.mount = SimpleMount(box)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end


const FlowBox = Efus.EfusTemplate(
    :FlowBox,
    FlowBoxBackend,
    Efus.TemplateParameter[
        :orient => Mousetrap.detail._Orientation => ORIENTATION_VERTICAL,
        :spacing => Integer,
    ]
)
