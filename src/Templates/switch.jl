mutable struct SwitchBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{SwitchBackend})::AttrapeMount
    btn = Mousetrap.Switch()
    processcommonargs!(c, btn)
    c[:switched] isa Function && connect_signal_switched!(btn, c[:switched])
    c.mount = SimpleSyncingMount(btn)
    c[:bind] isa Efus.AbstractReactant{Bool} && let r = c[:bind]
        set_is_active!(btn, getvalue(r))
        connect_signal_switched!(btn) do self::Mousetrap.Switch
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

function childgeometry!(frm::Efus.Component{SwitchBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    set_child!(frm.mount.widget, child.mount.widget)
    return
end

const Switch = Efus.EfusTemplate(
    :Switch,
    SwitchBackend,
    Efus.TemplateParameter[
        :switched => Function,
        :bind => Efus.AbstractReactant{Bool},
    ]
)
