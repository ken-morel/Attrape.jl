struct LabelBackend <: AttrapeBackend end

const Label = Efus.Component{LabelBackend}

function Efus.mount!(c::Label)::AttrapeMount
    label = Mousetrap.Label(c[:text]::String)
    c.mount = SimpleMount(label)
    processcommonargs!(c, label)
    c[:justify] isa JustifyMode && set_justify_mode!(label, c[:justify])
    c[:wrap] isa LabelWrapMode && set_wrap_mode!(label, c[:wrap])
    c[:ellipsize] isa EllipsizeMode && set_ellipsize_mode!(label, c[:ellipsize])
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end


function Efus.update!(c::Label)
    return updateutil!(c) do name, value
        label = c.mount.widget
        if name === :wrap
            set_wrap_mode!(label, value::LabelWrapMode)
        elseif name === :justify
            set_justify_mode!(label, value::JustifyMode)
        elseif name === :ellipsize
            set_ellipsize_mode!(label, value::EllipsizeMode)
        else
            missing
        end
    end
end

const label = Efus.EfusTemplate(
    :Label,
    LabelBackend,
    Efus.TemplateParameter[
        :text! => String,
        :justify => JustifyMode,
        :wrap => LabelWrapMode,
        :ellipsize => EllipsizeMode,
        COMMON_ARGS...,
    ]
)
