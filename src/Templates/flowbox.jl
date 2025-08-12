struct FlowBoxBackend <: AttrapeBackend end

const FlowBox = Component{FlowBoxBackend}

function Efus.mount!(c::FlowBox)::AttrapeMount
    box = Mousetrap.FlowBox(c[:orient]::Mousetrap.detail._Orientation)
    processcommonargs!(c, box)
    c[:spacing] isa Real && set_spacing!(box, c[:spacing])
    c.mount = SimpleMount(box)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end


function Efus.update!(c::FlowBox)
    return updateutil!(c) do name, value
        box = c.mount.widget
        if name === :spacing
            set_spacing!(box, value)
        elseif name === :orient
            set_orientation!(box, value)
        else
            missing
        end
    end
end

const flowBox = Efus.EfusTemplate(
    :FlowBox,
    FlowBoxBackend,
    Efus.TemplateParameter[
        :orient => Mousetrap.detail._Orientation => ORIENTATION_VERTICAL,
        :spacing => Real,
        COMMON_ARGS...,
    ]
)
