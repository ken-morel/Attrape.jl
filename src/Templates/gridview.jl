struct GridViewBackend <: AttrapeBackend end

const GridView = Efus.Component{FrameBackend}

function Efus.mount!(c::GridView)::AttrapeMount
    frame = Mousetrap.GridView(c[:orient]::Mousetrap.detail._Orientation)
    c.mount = SimpleMount(frame, outlet)
    processcommonargs!(c, frame)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end

const gridView = Efus.EfusTemplate(
    :GridView,
    GridViewBackend,
    Efus.TemplateParameter[
        :orient => Mousetrap.detail._Orientation => ORIENTATION_VERTICAL,
        :min => Integer,
        :max => Integer,
        COMMON_ARGS...,
    ]
)
