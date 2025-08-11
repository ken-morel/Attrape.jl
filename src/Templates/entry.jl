struct EntryBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{EntryBackend})
    entry = Mousetrap.Entry()
    c.mount = SimpleSyncingMount(entry)
    c[:changed] isa Function && connect_signal_text_changed!(c[:changed], entry)
    c[:activated] isa Function && connect_signal_activate!(c[:activated], entry)
    c[:width] isa Integer && set_max_width_chars!(entry, c[:width])
    c[:password] isa Bool && set_text_visible!(entry, !c[:password])
    c[:text] isa AbstractString && set_text!(entry, c[:text])
    processcommonargs!(c, entry)
    c[:bind] isa Efus.AbstractReactant && let r = c[:bind]
        set_text!(entry, getvalue(r))
        connect_signal_text_changed!(entry) do ::Mousetrap.Entry
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


const Entry = EfusTemplate(
    :Entry,
    EntryBackend,
    Efus.TemplateParameter[
        :changed => Function,
        :activated => Function,
        :bind => Efus.AbstractReactant,
        :password => Bool,
        :width => Integer,
    ]

)
