struct SpinnerBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{SpinnerBackend})::AttrapeMount
    spin = Mousetrap.Spinner()
    processcommonargs!(c, spin)
    Mousetrap.set_is_spinning!(spin, c[:spinning])
    c.mount = SimpleMount(spin)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

function Efus.update!(c::Efus.Component{SpinnerBackend})
    Mousetrap.set_is_spinning!(c.mount.widget, c[:spinning])
    return
end

const Spinner = Efus.EfusTemplate(
    :Spinner,
    SpinnerBackend,
    Efus.TemplateParameter[
        :spinning => Bool => true,
    ]
)
