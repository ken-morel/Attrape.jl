struct BoxBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{BoxBackend})::AttrapeMount
    box = Mousetrap.Box(mousetraporientation(something(c[:orient], EOrient(:vertical))))
    c.mount = SimpleMount(box)
    processcommonargs!(c, box)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end

function childgeometry!(box::Efus.Component{BoxBackend}, child::AttrapeComponent)
    isnothing(box.mount) && return
    Mousetrap.push_back!(box.mount.widget, child.mount.widget)
    return
end

const Box = Efus.EfusTemplate(
    :Box,
    BoxBackend,
    Efus.TemplateParameter[
        :orient! => EOrient,
    ]
)
