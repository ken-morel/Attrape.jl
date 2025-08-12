mutable struct ToggleButtonBackend <: AttrapeBackend end

const ToggleButton = Component{ToggleButtonBackend}

function Efus.mount!(c::ToggleButton)::AttrapeMount
    btn = Mousetrap.ToggleButton()
    processcommonargs!(c, btn)
    c[:clicked] isa Function && connect_signal_clicked!(btn, c[:clicked])
    c[:toggled] isa Function && connect_signal_toggled!(btn, c[:toggled])
    c[:frame] isa Bool && set_has_frame!(btn, c[:frame])
    c[:circular] isa Bool && set_is_circular!(btn, c[:circular])
    c.mount = SimpleSyncingMount(btn)
    c[:bind] isa Efus.AbstractReactant{Bool} && let r = c[:bind]
        set_is_active!(btn, getvalue(r))
        connect_signal_toggled!(btn) do self::Mousetrap.ToggleButton
            halfduplex!(c.mount, false) do
                notify!(r, get_is_active(self))
            end
            return
        end
        subscribe!(r, nothing) do val::Bool
            halfduplex!(c.mount, true) do
                set_is_active!(btn, val)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

function childgeometry!(frm::ToggleButton, child::AttrapeComponent)
    isnothing(frm.mount) && return
    set_child!(frm.mount.widget, child.mount.widget)
    return
end

const toggleButton = Efus.EfusTemplate(
    :ToggleButton,
    ToggleButtonBackend,
    Efus.TemplateParameter[
        :clicked => Function,
        :toggled => Function,
        :frame => Bool,
        :circular => Bool,
        :bind => Efus.AbstractReactant{Bool},
    ]
)
