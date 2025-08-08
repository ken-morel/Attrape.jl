struct FrameBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{FrameBackend})::AttrapeMount
    frame = Mousetrap.Frame()
    c[:label] isa String && Mousetrap.set_label_widget!(
        frame, Mousetrap.Label(c[:label])
    )
    outlet = if isnothing(c[:box])
        frame
    else
        box = Mousetrap.Box(mousetraporientation(something(c[:orient], EOrient(:vertical))))
        Mousetrap.set_child!(frame, box)
        box
    end
    c.mount = SimpleMount(frame, outlet)
    processcommonargs!(c, frame)
    if outlet === frame
        if length(c.children) >= 1
            mount!(last(c.children))
            length(c.children) > 1 && @warn(
                "Frame widget received more than one child.",
                " only the last was rendered"
            )
        end
    else
        mount!.(c.children)
    end

    return c.mount
end

function childgeometry!(frm::Efus.Component{FrameBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    if frm.mount.outlet == frm.mount.widget
        Mousetrap.set_child!(frm.mount.widget, child.mount.widget)
    else
        Mousetrap.push_back!(frm.mount.outlet, child.mount.widget)
    end
    return
end

const Frame = Efus.EfusTemplate(
    :Frame,
    FrameBackend,
    Efus.TemplateParameter[
        :label => String,
        :box => EOrient,
    ]
)
