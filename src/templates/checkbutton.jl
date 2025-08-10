struct CheckButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{CheckButtonBackend})::AttrapeMount
    btn = Mousetrap.CheckButton()
    processcommonargs!(c, btn)
    c[:toggled] isa Function && Mousetrap.connect_signal_toggled!(btn, c[:toggled])
    c.mount = SimpleMount(btn)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

function childgeometry!(frm::Efus.Component{FrameBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    Mousetrap.set_child!(frm.mount.widget, child.mount.widget)
    return
end

const CheckButton = Efus.EfusTemplate(
    :CheckButton,
    CheckButtonBackend,
    Efus.TemplateParameter[
        :toggled => Function,
    ]
)
