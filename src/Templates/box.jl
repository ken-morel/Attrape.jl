struct BoxBackend <: AttrapeBackend end
const Box = Component{BoxBackend}

function Efus.mount!(c::Box)
    box = Mousetrap.Box(c[:orient]::Mousetrap.detail._Orientation)
    processcommonargs!(c, box)
    c[:spacing] isa Integer && set_spacing!(box, c[:spacing])
    c.mount = SimpleMount(box)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end


function Efus.update!(c::Box)
    return updateutil!(c) do name, value
        if name === :orient
            set_orientation!(c.mount, value)
        else
            missing
        end
    end
end

const box = EfusTemplate(
    :Box,
    BoxBackend,
    Efus.TemplateParameter[
        :orient => Mousetrap.detail._Orientation => Mousetrap.ORIENTATION_VERTICAL,
        :spacing => Integer,
        COMMON_ARGS...,
    ]
)
