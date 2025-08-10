struct SpinButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{SpinButtonBackend})

end

const SpinButton = Efus.EfusTemplate(
    :SpinButton,
    SpinButtonBackend,
    Efus.TemplateParameter[
        :range => UnitRange => 0:100,
    ]
)
