mutable struct ToggleButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ToggleButtonBackend})::AttrapeMount
    btn = Mousetrap.ToggleButton()
    processcommonargs!(c, btn)
    c[:clicked] isa Function && Mousetrap.connect_signal_clicked!(btn, c[:clicked])
    c[:toggled] isa Function && Mousetrap.connect_signal_toggled!(btn, c[:toggled])
    c[:frame] isa Bool && Mousetrap.set_has_frame!(btn, c[:frame])
    c[:circular] isa Bool && Mousetrap.set_is_circular!(btn, c[:circular])
    c.mount = SimpleSyncingMount(btn)
    c[:bind] isa Efus.AbstractReactant{Bool} && let r = c[:bind]
        Mousetrap.set_is_active!(btn, getvalue(c[:bind]))
        Mousetrap.connect_signal_toggled!(btn) do self::Mousetrap.ToggleButton
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

function childgeometry!(frm::Efus.Component{ToggleButtonBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    Mousetrap.set_child!(frm.mount.widget, child.mount.widget)
    return
end

const ToggleButton = Efus.EfusTemplate(
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
