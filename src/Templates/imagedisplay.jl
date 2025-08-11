struct ImageDisplayBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ImageDisplayBackend})::AttrapeMount
    img = Mousetrap.ImageDisplay()
    c[:path] isa String && create_from_file!(img, c[:path])
    processcommonargs!(c, img)
    c.mount = SimpleMount(img)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const ImageDisplay = Efus.EfusTemplate(
    :ImageDisplay,
    ImageDisplayBackend,
    Efus.TemplateParameter[
        :path => String,
    ]
)
