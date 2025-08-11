struct ScaleBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ScaleBackend})
    scl = Mousetrap.Scale(c[:range]::UnitRange{<:Integer})
    processcommonargs!(c, scl)
    Mousetrap.set_orientation!(scl, c[:orient])
    c.mount = SimpleSyncingMount(scl)
    c[:drawvalue] isa Bool && Mousetrap.set_shound_draw_value!(scl, c[:drawvalue])
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        Mousetrap.set_value!(scl, getvalue(r))
        Mousetrap.connect_signal_value_changed!(scl) do self::Mousetrap.Scale
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
                Mousetrap.set_value!(scl, val)
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

const Scale = Efus.EfusTemplate(
    :Scale,
    ScaleBackend,
    Efus.TemplateParameter[
        :range => UnitRange{<:Integer} => 0:100,
        :orient => Mousetrap.detail._Orientation => Mousetrap.ORIENTATION_HORIZONTAL,
        :bind => Efus.AbstractReactant{<:Real},
        :changed => Function,
        :drawvalue => Bool,
    ]
)

Mousetrap.Scale(
    prm::UnitRange{<:Integer},
) = Mousetrap.Scale(first(prm), last(prm), step(prm))
