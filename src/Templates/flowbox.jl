struct FlowboxBackend <: AttrapeBackend end

const Flowbox = Component{FlowboxBackend}

function Efus.mount!(c::Flowbox)::AttrapeMount
    box = Mousetrap.FlowBox(c[:orient]::Mousetrap.detail._Orientation)
    processcommonargs!(c, box)
    c[:spacing] isa Real && set_spacing!(box, c[:spacing])
    c.mount = SimpleMount(box)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end


const flowbox = Efus.EfusTemplate(
    :Flowbox,
    FlowboxBackend,
    Efus.TemplateParameter[
        :orient => Mousetrap.detail._Orientation => ORIENTATION_VERTICAL,
        :spacing => Real,
    ]
)
