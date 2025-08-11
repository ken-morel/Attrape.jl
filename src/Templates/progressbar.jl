struct ProgressBarBackend <: AttrapeBackend end

function Efus.mount!(c::Efus.Component{ProgressBarBackend})
    scl = Mousetrap.ProgressBar()
    processcommonargs!(c, scl)
    c.mount = SimpleMount(scl)
    c[:text] isa Union{Bool, AbstractString} && let txt = c[:text]
        Mousetrap.set_show_text!(scl, true)
        txt isa AbstractString && Mousetrap.set_text!(scl, txt)
    end
    c[:bind] isa Efus.AbstractReactant{<:Real} && let r = c[:bind]
        Mousetrap.set_value!(scl, getvalue(r))
        subscribe!(r, nothing) do ::Nothing, val::Real
            try
                Mousetrap.set_value!(scl, val)
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
