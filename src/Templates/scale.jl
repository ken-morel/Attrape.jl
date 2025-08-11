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
