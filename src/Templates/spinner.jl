struct SpinnerBackend <: AttrapeBackend end

const Spinner = Component{SpinnerBackend}

function Efus.mount!(c::Spinner)
    spin = Mousetrap.Spinner()
    c.mount = SimpleMount(spin)
    processcommonargs!(c, spin)
    set_is_spinning!(spin, c[:spinning]::Bool)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

function Efus.update!(c::Spinner)
    return updateutil!(c) do name, value
        if name === :spinning
            set_is_spinning!(c.mount.widget, value::Bool)
        else
            missing
        end
    end
end

const spinner = Efus.EfusTemplate(
    :Spinner,
    SpinnerBackend,
    Efus.TemplateParameter[
        :spinning => Bool => true,
        COMMON_ARGS...,
    ]
)
