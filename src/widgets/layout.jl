function apply_layout!(component::AttrapeComponent, widget::Mousetrap.Widget)
    !isnothing(component.size) && Mousetrap.set_size_request!(widget, Mousetrap.Vector2f(component.size.x, component.size.y))
    if !isnothing(component.margin)
        Mousetrap.set_margin_top!(widget, component.margin.y)
        Mousetrap.set_margin_bottom!(widget, component.margin.y)
        Mousetrap.set_margin_start!(widget, component.margin.x)
        Mousetrap.set_margin_end!(widget, component.margin.x)
    end
    !isnothing(component.expand) && Mousetrap.set_expand!(widget, component.expand)
    !isnothing(component.halign) && Mousetrap.set_horizontal_alignment!(widget, component.halign)
    return !isnothing(component.valign) && Mousetrap.set_vertical_alignment!(widget, component.valign)
end
