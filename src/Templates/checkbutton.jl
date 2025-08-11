mutable struct CheckButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{CheckButtonBackend})::AttrapeMount
    btn = Mousetrap.CheckButton()
    processcommonargs!(c, btn)
    c[:toggled] isa Function && connect_signal_toggled!(btn, c[:toggled])
    c.mount = SimpleSyncingMount(btn)
    c[:bind] isa Efus.AbstractReactant{CheckButtonState} && let r = c[:bind]
        set_state!(btn, getvalue(r))
        connect_signal_toggled!(btn) do self::Mousetrap.CheckButton
            halfduplex!(c.mount, false) do
                notify!(r, get_state(self))
            end
            return
        end
        subscribe!(r, nothing) do val::CheckButtonState
            halfduplex!(c.mount, true) do
                set_state!(btn, val)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

function childgeometry!(frm::Efus.Component{CheckButtonBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    set_child!(frm.mount.widget, child.mount.widget)
    return
end

const CheckButton = Efus.EfusTemplate(
    :CheckButton,
    CheckButtonBackend,
    Efus.TemplateParameter[
        :toggled => Function,
        :bind => Efus.AbstractReactant{CheckButtonState},
    ]
)
