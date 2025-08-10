mutable struct SwitchBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{SwitchBackend})::AttrapeMount
    btn = Mousetrap.Switch()
    processcommonargs!(c, btn)
    c[:switched] isa Function && Mousetrap.connect_signal_switched!(btn, c[:switched])
    c.mount = SimpleSyncingMount(btn)
    c[:bind] isa Efus.AbstractReactant{Bool} && let r = c[:bind]
        Mousetrap.set_is_active!(btn, getvalue(c[:bind]))
        Mousetrap.connect_signal_toggled!(btn) do self::Mousetrap.Switch
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideMousetrap
            try
                notify!(r, Mousetrap.get_is_active(self))
            catch e
                errorincallback(e)
            finally
                c.mount.updateside = _UpdateSideNone
            end
            return
        end
        subscribe!(r, nothing) do ::Nothing, val::Bool
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideAttrape
            try
                Mousetrap.set_is_active!(btn, val)
            catch e
                errorincallback(e)
            finally
                c.mount.updateside = _UpdateSideNone
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

function childgeometry!(frm::Efus.Component{SwitchBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    Mousetrap.set_child!(frm.mount.widget, child.mount.widget)
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
