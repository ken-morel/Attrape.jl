struct FrameBackend <: AttrapeBackend
end

function Efus.mount!(c::Efus.Component{FrameBackend})::AttrapeMount
    frame = Mousetrap.Frame()
    return c.mount = SimpleMount(frame)
end

const Frame = Efus.EfusTemplate(
    :Frame,
    FrameBackend,
    Efus.TemplateParameter[]
)
