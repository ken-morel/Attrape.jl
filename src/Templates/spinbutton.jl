struct SpinButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{SpinButtonBackend})
    rng = Mousetrap.SpinButton(c[:range]::UnitRange{<:Integer})
    processcommonargs!(c, rng)
    set_orientation!(rng, c[:orient])
    c.mount = SimpleSyncingMount(rng)
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        set_value!(rng, getvalue(r))
        connect_signal_value_changed!(rng) do self::Mousetrap.SpinButton
            halfduplex!(c.mount, false) do
                notify!(r, Mousetrap.get_value(self))
            end
            return
        end
        subscribe!(r, nothing) do val::Real
            halfduplex!(c.mount, true) do
                set_value!(rng, val)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const SpinButton = Efus.EfusTemplate(
    :SpinButton,
    SpinButtonBackend,
    Efus.TemplateParameter[
        :range => UnitRange{<:Integer} => 0:100,
        :orient => Mousetrap.detail._Orientation => ORIENTATION_HORIZONTAL,
        :bind => Efus.AbstractReactant{<:Real},
        :changed => Function,
    ]
)

Mousetrap.SpinButton(
    prm::UnitRange{<:Integer},
) = Mousetrap.SpinButton(first(prm), last(prm), step(prm))
