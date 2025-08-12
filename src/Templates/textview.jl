struct TextViewBackend <: AttrapeBackend end

const TextView = Component{TextViewBackend}

function Efus.mount!(c::TextView)
    tview = Mousetrap.TextView()
    c.mount = SimpleSyncingMount(tview)
    processcommonargs!(c, tview)
    c[:changed] isa Function && connect_signal_text_changed!(c[:changed], tview)
    c[:text] isa AbstractString && set_text!(tview, c[:text])
    c[:justify] isa JustifyMode && set_justify_mode!(tview, c[:justify])
    c[:bind] isa Efus.AbstractReactant && let r = c[:bind]
        set_text!(tview, getvalue(r))
        connect_signal_text_changed!(tview) do ::Mousetrap.TextView
            halfduplex!(c.mount, false) do
                notify!(r, get_text(tview))
            end
            return
        end
        subscribe!(r, nothing) do val
            halfduplex!(c.mount, true) do
                set_text!(tview, val)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end


function Efus.update!(c::TextView)
    return updateutil!(c) do name, value
        tview = c.mount.widget
        if name === :text
            set_text!(tview, value::AbstractString)
        elseif name == :justify
            set_justify_mode!(tview, value::JustifyMode)
        else
            missing
        end
    end
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
