mutable struct CheckButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{CheckButtonBackend})::AttrapeMount
    btn = Mousetrap.CheckButton()
    processcommonargs!(c, btn)
    c[:toggled] isa Function && Mousetrap.connect_signal_toggled!(btn, c[:toggled])
    c.mount = SimpleSyncingMount(btn)
    c[:bind] isa Efus.AbstractReactant{Mousetrap.CheckButtonState} && let r = c[:bind]
        Mousetrap.set_state!(btn, getvalue(r))
        Mousetrap.connect_signal_toggled!(btn) do self::Mousetrap.CheckButton
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideMousetrap
            try
                notify!(r, Mousetrap.get_state(self))
            catch e
                errorincallback(e)
            finally
                c.mount.updateside = _UpdateSideNone
            end
            return
        end
        subscribe!(r, nothing) do ::Nothing, val::Mousetrap.CheckButtonState
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideAttrape
            try
                Mousetrap.set_state!(btn, val)
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

function childgeometry!(frm::Efus.Component{CheckButtonBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    Mousetrap.set_child!(frm.mount.widget, child.mount.widget)
    return
end

const CheckButton = Efus.EfusTemplate(
    :CheckButton,
    CheckButtonBackend,
    Efus.TemplateParameter[
        :toggled => Function,
        :bind => Efus.AbstractReactant{Mousetrap.CheckButtonState},
    ]
)
