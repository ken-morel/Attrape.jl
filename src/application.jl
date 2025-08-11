Base.@kwdef mutable struct Application <: Atak.Application
    const id::String
    const mousetrap::Mousetrap.Application
    const home::Union{PageBuilder, AbstractPage, Nothing}
    const namespace::AbstractNamespace
    store::Union{Namespace, Nothing} = nothing
    toplevel::Union{Window, Nothing} = nothing
end

function application(id::String = "cm.rbs.engon.attrape.test"; home::Union{PageBuilder, AbstractPage, Nothing})
    return Application(;
        id, home,
        mousetrap = Mousetrap.Application(id),
        namespace = DictNamespace()
    )
end

function init!(app::Application)
    @info "[Attrape]" "Initializing application $(app.id)"
    Mousetrap.connect_signal_activate!(app.mousetrap) do ::Mousetrap.Application
        @info "[Attrape]" "Mounting application $(app.id)"
        try
            Efus.mount!(app)
        catch exception
            printstyled(stderr, "[ERROR] "; bold = true, color = :red)
            printstyled(stderr, "During mount: "; bold = true)
            Base.showerror(stderr, exception, catch_backtrace())
            print(stderr, "\n")
            Mousetrap.quit!(app.mousetrap)
        end
        return
    end
    return
end

function Efus.mount!(app::Application)
    app.toplevel = createwindow(app) do ctx::PageContext
        if app.home isa PageBuilder
            build(app.home, ctx)
        else
            app.home
        end
    end
    return present!(app.toplevel)
end


function run!(app::Application)
    init!(app)
    Mousetrap.run!(app.mousetrap)
    return 0
end
