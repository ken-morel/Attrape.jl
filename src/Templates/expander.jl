struct ExpanderBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ExpanderBackend})::AttrapeMount
    frame = Mousetrap.Expander()
    c[:label] isa String && set_label_widget!(
        frame, Mousetrap.Label(c[:label])
    )
    c[:margin] isa Efus.EEdgeInsets && let m = c[:margin]
        set_margin_bottom!(frame, m.bottom)
        set_margin_top!(frame, m.top)
        set_margin_start!(frame, m.left)
        set_margin_end!(frame, m.right)
    end
    outlet = if isnothing(c[:box])
        frame
    else
        box = Mousetrap.Box(something(c[:orient], ORIENTATION_VERTICAL))
        set_child!(frame, box)
        box
    end
    c.mount = SimpleMount(frame, outlet)
    processcommonargs!(c, frame)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    if outlet === frame
        if length(c.children) >= 1
            mount!(last(c.children))
            length(c.children) > 1 && @warn(
                "Expander widget received more than one child.",
                " only the last was mounted."
            )
        end
    else
        mount!.(c.children)
    end
    return c.mount
end

function childgeometry!(frm::Efus.Component{ExpanderBackend}, child::AttrapeComponent)
    isnothing(frm.mount) && return
    if frm.mount.outlet == frm.mount.widget
        set_child!(frm.mount.widget, child.mount.widget)
    else
        push_back!(frm.mount.outlet, child.mount.widget)
    end
    return
end

const Expander = Efus.EfusTemplate(
    :Expander,
    ExpanderBackend,
    Efus.TemplateParameter[
        :label => String,
        :box => Mousetrap.detail._Orientation,
        :margin => Efus.EEdgeInsets{Number, nothing},
    ]
)
