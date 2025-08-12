struct ButtonBackend <: AttrapeBackend end

const Button = Component{ButtonBackend}

function Efus.mount!(c::Button)
    btn = Mousetrap.Button()
    processcommonargs!(c, btn)
    c[:clicked] isa Function && connect_signal_clicked!(c[:clicked], btn)
    c[:frame] isa Bool && set_has_frame!(btn, c[:frame])
    c[:circular] isa Bool && set_is_circular!(btn, c[:circular])
    c.mount = SimpleMount(btn)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

function Efus.update!(c::Button)
    return updateutil!(c) do name, value
        if name === :frame
            set_has_frame!(c.mount.widget, value)
        elseif name === :circular
            set_is_circular!(c.mount.widget, value)
        else
            missing
        end
    end
end

const button = EfusTemplate(
    :Button,
    ButtonBackend,
    Efus.TemplateParameter[
        :clicked => Function,
        :frame => Bool,
        :circular => Bool,
        COMMON_ARGS...,
    ]
)
