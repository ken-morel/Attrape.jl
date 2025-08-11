mutable struct CheckButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{CheckButtonBackend})::AttrapeMount
    btn = Mousetrap.CheckButton()
    processcommonargs!(c, btn)
    c[:toggled] isa Function && connect_signal_toggled!(btn, c[:toggled])
    c.mount = SimpleSyncingMount(btn)
    c[:bind] isa Efus.AbstractReactant{CheckButtonState} && let r = c[:bind]
        set_state!(btn, getvalue(r))
        connect_signal_toggled!(btn) do self::Mousetrap.CheckButton
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideMousetrap
            try
                notify!(r, get_state(self))
            catch e
                errorincallback(e)
            finally
                c.mount.updateside = _UpdateSideNone
            end
            return
        end
        subscribe!(r, nothing) do val::CheckButtonState
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideAttrape
            try
                set_state!(btn, val)
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
