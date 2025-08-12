mutable struct ToggleButtonBackend <: AttrapeBackend end

const ToggleButton = Component{ToggleButtonBackend}

function Efus.mount!(c::ToggleButton)::AttrapeMount
    btn = Mousetrap.ToggleButton()
    c.mount = SimpleSyncingMount(btn)
    processcommonargs!(c, btn)
    c[:clicked] isa Function && connect_signal_clicked!(btn, c[:clicked])
    c[:toggled] isa Function && connect_signal_toggled!(btn, c[:toggled])
    c[:frame] isa Bool && set_has_frame!(btn, c[:frame])
    c[:circular] isa Bool && set_is_circular!(btn, c[:circular])
    c[:active] isa Bool && set_is_active!(btn, c[:active])
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


function Efus.update!(c::ToggleButton)
    return updateutil!(c) do name, value
        btn = c.mount.widget
        if name === :frame
            set_has_frame!(btn, value::Bool)
        elseif name === :circular
            set_is_circular!(btn, value::Bool)
        elseif name === :active
            set_is_active!(btn, value::Bool)
        else
            missing
        end
    end
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
        :active => Bool,
        COMMON_ARGS...,
    ]
)
