struct SpinButtonBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{SpinButtonBackend})
    rng = Mousetrap.SpinButton(c[:range]::UnitRange{<:Integer})
    processcommonargs!(c, rng)
    Mousetrap.set_orientation!(rng, c[:orient])
    c.mount = SimpleSyncingMount(rng)
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        Mousetrap.set_value!(rng, getvalue(r))
        Mousetrap.connect_signal_value_changed!(rng) do self::Mousetrap.SpinButton
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideMousetrap
            try
                notify!(r, Mousetrap.get_value(self))
            catch e
                errorincallback(e)
            finally
                c.mount.updateside = _UpdateSideNone
            end
            return
        end
        subscribe!(r, nothing) do ::Nothing, val::Real
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideAttrape
            try
                Mousetrap.set_value!(rng, val)
            catch e
                errorincallback(e)
            finally
                c.mount.updateside = _UpdateSideNone
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
        :orient => Mousetrap.detail._Orientation => Mousetrap.ORIENTATION_HORIZONTAL,
        :bind => Efus.AbstractReactant{<:Real},
        :changed => Function,
    ]
)

Mousetrap.SpinButton(
    prm::UnitRange{<:Integer},
) = Mousetrap.SpinButton(first(prm), last(prm), step(prm))
