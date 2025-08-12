struct SpinButtonBackend <: AttrapeBackend end

const SpinButton = Component{SpinButtonBackend}

function Efus.mount!(c::SpinButton)
    rng = Mousetrap.SpinButton(c[:range]::UnitRange{<:Real})
    c.mount = SimpleSyncingMount(rng)
    processcommonargs!(c, rng)
    set_orientation!(rng, c[:orient])
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


function Efus.update!(c::Button)
    return updateutil!(c) do name, value
        if name === :orient
            set_orientation!(c.mount.widget, value)
        else
            missing
        end
    end
end

const spinButton = EfusTemplate(
    :SpinButton,
    SpinButtonBackend,
    Efus.TemplateParameter[
        :range => UnitRange{<:Real} => 0:100,
        :orient => Mousetrap.detail._Orientation => ORIENTATION_HORIZONTAL,
        :bind => Efus.AbstractReactant{<:Real},
        :changed => Function,
        COMMON_ARGS...,
    ]
)

Mousetrap.SpinButton(
    prm::UnitRange{<:Integer},
) = Mousetrap.SpinButton(first(prm), last(prm), step(prm))
