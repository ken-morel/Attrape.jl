struct BoxBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{BoxBackend})::AttrapeMount
    box = Mousetrap.Box(c[:orient]::Mousetrap.detail._Orientation)
    processcommonargs!(c, box)
    c[:spacing] isa Integer && set_spacing!(box, c[:spacing])
    c.mount = SimpleMount(box)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end

const Box = Efus.EfusTemplate(
    :Box,
    BoxBackend,
    Efus.TemplateParameter[
        :orient => Mousetrap.detail._Orientation => Mousetrap.ORIENTATION_VERTICAL,
        :spacing => Integer,
    ]
)
