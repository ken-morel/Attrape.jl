struct SeparatorBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{SeparatorBackend})::AttrapeMount
    sep = Mousetrap.Separator()
    processcommonargs!(c, sep)
    c[:margin] isa Integer && set_margin!(sep, c[:margin])
    c[:expand] isa EOrient && let e = c[:expand]
        v = e ∈ [:both, :vertical]
        h = e ∈ [:both, :horizontal]
        set_expand_vertically!(sep, v)
        set_expand_horizontally!(sep, h)
    end
    c.mount = SimpleMount(sep)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const Separator = Efus.EfusTemplate(
    :Separator,
    SeparatorBackend,
    Efus.TemplateParameter[
        :margin => Integer,
        :expand => Efus.EOrient,
    ]
)
