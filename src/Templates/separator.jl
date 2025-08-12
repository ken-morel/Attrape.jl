struct SeparatorBackend <: AttrapeBackend end

const Separator = Component{SeparatorBackend}

function Efus.mount!(c::Separator)
    sep = Mousetrap.Separator()
    c.mount = SimpleMount(sep)
    processcommonargs!(c, sep)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const separator = Efus.EfusTemplate(
    :Separator,
    SeparatorBackend,
    Efus.TemplateParameter[
        COMMON_ARGS...,
    ]
)
