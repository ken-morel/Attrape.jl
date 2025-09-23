function apply_layout!(component, widget)
    !isnothing(component.size) && Mousetrap.set_size_request!(widget, component.size.width, component.size.height)
    if !isnothing(component.margin)
        Mousetrap.set_margin_top!(widget, component.margin.height)
        Mousetrap.set_margin_bottom!(widget, component.margin.height)
        Mousetrap.set_margin_start!(widget, component.margin.width)
        Mousetrap.set_margin_end!(widget, component.margin.width)
    end
    !isnothing(component.expand) && Mousetrap.set_expand!(widget, component.expand)
    !isnothing(component.halign) && Mousetrap.set_halign!(widget, getproperty(Mousetrap.Align, component.halign))
    !isnothing(component.valign) && Mousetrap.set_valign!(widget, getproperty(Mousetrap.Align, component.valign))
end
