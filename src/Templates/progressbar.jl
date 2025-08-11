struct ProgressBarBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ProgressBarBackend})
    scl = Mousetrap.ProgressBar()
    processcommonargs!(c, scl)
    c.mount = SimpleMount(scl)
    c[:text] isa Union{Bool, AbstractString} && let txt = c[:text]
        set_show_text!(scl, true)
        txt isa AbstractString && set_text!(scl, txt)
    end
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        set_fraction!(scl, getvalue(r))
        subscribe!(r, nothing) do val::Real
            try
                set_fraction!(scl, val)
            catch e
                errorincallback(e)
            end
        end
    end
    isnothing(c.parent) || childgeometry!(c.parent, c)
    return c.mount
end

const ProgressBar = Efus.EfusTemplate(
    :ProgressBar,
    ProgressBarBackend,
    Efus.TemplateParameter[
        :bind => Efus.AbstractReactant{<:Real},
        :text => Union{Bool, AbstractString},
    ]
)
