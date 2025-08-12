struct TextViewBackend <: AttrapeBackend end

const TextView = Component{TextViewBackend}

function Efus.mount!(c::TextView)
    entry = Mousetrap.TextView()
    c.mount = SimpleSyncingMount(entry)
    processcommonargs!(c, entry)
    c[:changed] isa Function && connect_signal_text_changed!(c[:changed], entry)
    c[:text] isa AbstractString && set_text!(entry, c[:text])
    c[:padding] isa Efus.EEdgeInsets && let m = c[:margin]
        set_margin_bottom!(entry, m.bottom)
        set_margin_top!(entry, m.top)
        set_margin_start!(entry, m.left)
        set_margin_end!(entry, m.right)
    end
    c[:justify] isa JustifyMode && set_justify_mode!(entry, c[:justify])
    c[:bind] isa Efus.AbstractReactant && let r = c[:bind]
        set_text!(entry, getvalue(r))
        connect_signal_text_changed!(entry) do ::Mousetrap.TextView
            halfduplex!(c.mount, false) do
                notify!(r, get_text(entry))
            end
            return
        end
        subscribe!(r, nothing) do val
            halfduplex!(c.mount, true) do
                set_text!(entry, val)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end


const textView = EfusTemplate(
    :TextView,
    TextViewBackend,
    Efus.TemplateParameter[
        :changed => Function,
        :padding => EEdgeInsets{Real, nothing},
        :bind => Efus.AbstractReactant{<:AbstractString},
        :justify => JustifyMode,
        :text => String,
        COMMON_ARGS...,
    ]

)
