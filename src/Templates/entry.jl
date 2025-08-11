struct EntryBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{EntryBackend})
    entry = Mousetrap.Entry()
    c.mount = SimpleSyncingMount(entry)
    c[:bind] isa AbstractReactant && let r = c[:bind]
    end
    return c.mount

end

const Entry = EfusTemplate(
    :Entry,
    EntryBackend,
    Efus.TemplateParameter[]

)
