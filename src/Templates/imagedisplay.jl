struct ImageDisplayBackend <: AttrapeBackend end

const ImageDisplay = Efus.Component{ImageDisplayBackend}

function Efus.mount!(c::ImageDisplay)::AttrapeMount
    img = Mousetrap.ImageDisplay()
    processcommonargs!(c, img)
    c[:path] isa String && create_from_file!(img, c[:path])
    c.mount = SimpleMount(img)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const imageDisplay = Efus.EfusTemplate(
    :ImageDisplay,
    ImageDisplayBackend,
    Efus.TemplateParameter[
        :path => String,
        COMMON_ARGS...,
    ]
)
