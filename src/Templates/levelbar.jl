struct LevelBarBackend <: AttrapeBackend end

const LevelBar = Efus.Component{LevelBarBackend}

function Efus.mount!(c::LevelBar)
    scl = Mousetrap.LevelBar(c[:range]::UnitRange{<:Integer})
    c.mount = SimpleMount(scl)
    processcommonargs!(c, scl)
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        set_value!(scl, getvalue(r))
        subscribe!(r, nothing) do val::Real
            try
                set_value!(scl, val)
            catch e
                errorincallback(e)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const levelBar = Efus.EfusTemplate(
    :LevelBar,
    LevelBarBackend,
    Efus.TemplateParameter[
        :range => UnitRange{<:Integer} => 0:100,
        :bind => Efus.AbstractReactant{<:Real},
        COMMON_ARGS...,
    ]
)

Mousetrap.LevelBar(
    prm::UnitRange{<:Integer},
) = Mousetrap.LevelBar(first(prm), last(prm))
