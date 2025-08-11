struct FrameBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{FrameBackend})::AttrapeMount
    frame = Mousetrap.Frame()
    c[:label] isa String && Mousetrap.set_label_widget!(
        frame, Mousetrap.Label(c[:label])
    )
    c[:margin] isa Efus.EEdgeInsets && let m = c[:margin]
        Mousetrap.set_margin_bottom!(frame, m.bottom)
        Mousetrap.set_margin_top!(frame, m.top)
        Mousetrap.set_margin_start!(frame, m.left)
        Mousetrap.set_margin_end!(frame, m.right)
    end
    outlet = if isnothing(c[:box])
        frame
    else
        box = Mousetrap.Box(something(c[:orient], Mousetrap.ORIENTATION_VERTICAL))
        Mousetrap.set_child!(frame, box)
        box
    end
    c.mount = SimpleMount(frame, outlet)
    processcommonargs!(c, frame)
    isnothing(c.parent) || childgeometry!(c.parent, c)
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
        :box => Mousetrap.detail._Orientation,
        :margin => Efus.EEdgeInsets{Number, nothing},
    ]
)
