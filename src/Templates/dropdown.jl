struct DropdownBackend <: AttrapeBackend end

using Efus: AbstractReactant
function Efus.mount!(c::Efus.Component{DropdownBackend})
    drop = Mousetrap.DropDown()
    processcommonargs!(c, drop)
    c.mount = SimpleSyncingMount(drop)
    if c[:bind] isa Efus.AbstractReactant{<:Real}
        r = c[:bind]
        for (key, value) in pairs(c[:choices])
            push_back!(drop, value) do ::Mousetrap.DropDown
                notify!(r, key)
            end
        end
        subscribe!(r, nothing) do v
            choices = c[:choices]::Dict
            try
                choice = choices[v]
            catch
                @error "Invalid dropdown choice" choice "permited" c[:choices]
            else
                set_selected!(drop, choice)
            end
        end
    else
        push_back!.((drop,), values(c[:choices]))
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end


const Dropdown = Efus.EfusTemplate(
    :Dropdown,
    DropdownBackend,
    Efus.TemplateParameter[
        :choices! => Dict{Any, AbstractString},
        :bind => Efus.AbstractReactant{<:Real},
    ]
)
