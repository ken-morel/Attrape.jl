struct AdjustmentBackend <: AttrapeBackend end

const Adjustment = Component{AdjustmentBackend}

function Efus.mount!(c::Adjustment)
    scl = Mousetrap.Adjustment(c[:range]::UnitRange{<:Real}, c[:value]::Real)
    processcommonargs!(c, scl)
    set_orientation!(scl, c[:orient]::Mousetrap.detail._Orientation)
    c.mount = SimpleSyncingMount(scl)
    c[:value] isa Real && set_value!(scl, c[:value])
    c[:changed] isa Function && connect_signal_value_changed!(scl, c[:changed])
    c[:propschanged] isa Function && connect_signal_properties_changed!(scl, c[:propschanged])
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        set_value!(scl, getvalue(r))
        connect_signal_value_changed!(scl) do self::Mousetrap.Adjustment
            halfduplex!(c.mount, false) do
                notify!(r, Mousetrap.get_value(self))
            end
            return
        end
        subscribe!(r, nothing) do val::Real
            halfduplex!(c.mount, true) do
                set_value!(scl, val)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const adjustment = Efus.EfusTemplate(
    :Adjustment,
    AdjustmentBackend,
    Efus.TemplateParameter[
        :range! => UnitRange{<:Real},
        :value! => Real,
        :bind => Efus.AbstractReactant{<:Real},
        :changed => Function,
        :propschanged => Function,
        COMMON_ARGS...,
    ]
)

Mousetrap.Adjustment(prm::UnitRange{<:Real}, v::Real) =
    Mousetrap.Adjustment(v, first(prm), last(prm), step(prm))
