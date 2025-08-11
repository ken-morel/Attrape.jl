struct ScaleBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ScaleBackend})
    scl = Mousetrap.Scale(c[:range]::UnitRange{<:Integer})
    processcommonargs!(c, scl)
    set_orientation!(scl, c[:orient])
    c.mount = SimpleSyncingMount(scl)
    c[:drawvalue] isa Bool && set_should_draw_value!(scl, c[:drawvalue])
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        set_value!(scl, getvalue(r))
        connect_signal_value_changed!(scl) do self::Mousetrap.Scale
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
        subscribe!(r, nothing) do val::Real
            c.mount.updateside !== _UpdateSideNone && return
            c.mount.updateside = _UpdateSideAttrape
            try
                set_value!(scl, val)
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
        :orient => Mousetrap.detail._Orientation => ORIENTATION_HORIZONTAL,
        :bind => Efus.AbstractReactant{<:Real},
        :changed => Function,
        :drawvalue => Bool,
    ]
)

Mousetrap.Scale(
    prm::UnitRange{<:Integer},
) = Mousetrap.Scale(first(prm), last(prm), step(prm))
