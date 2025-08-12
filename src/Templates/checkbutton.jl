mutable struct CheckbuttonBackend <: AttrapeBackend end

const Checkbutton = Component{CheckbuttonBackend}

function Efus.mount!(c::CheckButton)
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

function childgeometry!(frm::Checkbutton, child::AttrapeComponent)
    isnothing(frm.mount) && return
    set_child!(frm.mount.widget, child.mount.widget)
    return
end

const checkbutton = Efus.EfusTemplate(
    :Checkbutton,
    CheckbuttonBackend,
    Efus.TemplateParameter[
        :toggled => Function,
        :bind => Efus.AbstractReactant{CheckButtonState},
    ]
)
