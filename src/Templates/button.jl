struct ButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ButtonBackend})::AttrapeMount
    btn = Mousetrap.Button()
    processcommonargs!(c, btn)
    c[:clicked] isa Function && Mousetrap.connect_signal_clicked!(c[:clicked], btn)
    c[:frame] isa Bool && Mousetrap.set_has_frame!(btn, c[:frame])
    c[:circular] isa Bool && Mousetrap.set_is_circular!(btn, c[:circular])
    c.mount = SimpleMount(btn)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const Button = Efus.EfusTemplate(
    :Button,
    ButtonBackend,
    Efus.TemplateParameter[
        :clicked => Function,
        :frame => Bool,
        :circular => Bool,
    ]
)
