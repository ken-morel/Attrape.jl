struct EntryBackend <: AttrapeBackend end

const Entry = Efus.Component{EntryBackend}

function Efus.mount!(c::Entry)
    entry = Mousetrap.Entry()
    c.mount = SimpleSyncingMount(entry)
    processcommonargs!(c, entry)
    c[:changed] isa Function && connect_signal_text_changed!(c[:changed], entry)
    c[:activated] isa Function && connect_signal_activate!(c[:activated], entry)
    c[:width] isa Integer && set_max_width_chars!(entry, c[:width])
    c[:password] isa Bool && set_text_visible!(entry, !c[:password])
    c[:text] isa AbstractString && set_text!(entry, c[:text])
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

function Efus.update!(c::Entry)
    return updateutil!(c) do name, value
        entry = c.mount.widget
        if name === :width
            set_max_width_chars!(entry, value::Real)
        elseif name === :password
            set_text_visible!(entry, !value::Bool)
        elseif name === :text
            set_text!(entry, !value::AbstractString)
        else
            missing
        end
    end
end

const entry = EfusTemplate(
    :Entry,
    EntryBackend,
    Efus.TemplateParameter[
        :changed => Function,
        :activated => Function,
        :bind => Efus.AbstractReactant{<:AbstractString},
        :password => Bool,
        :width => Integer,
        COMMON_ARGS...,
    ]

)
