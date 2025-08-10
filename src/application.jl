Base.@kwdef mutable struct Application <: Atak.Application
    const id::String
    const mousetrap::Mousetrap.Application
    const home::Union{PageBuilder, Nothing}
    const namespace::AbstractNamespace
    store::Union{Namespace, Nothing} = nothing
    toplevel::Union{Window, Nothing} = nothing
end

function application(id::String; home::Union{PageBuilder, Nothing})
    return Application(;
        id, home,
        mousetrap = Mousetrap.Application(id),
        namespace = DictNamespace()
    )
end

function init!(app::Application)
    Mousetrap.connect_signal_activate!(app.mousetrap) do ::Mousetrap.Application
        try
            Efus.mount!(app)
        catch exception
            printstyled(stderr, "[ERROR] "; bold = true, color = :red)
            printstyled(stderr, "In Attrape: "; bold = true)
            Base.showerror(stderr, exception, catch_backtrace())
            print(stderr, "\n")
            Mousetrap.quit!(app.mousetrap)
        end
        return nothing
    end
    return
end

function Efus.mount!(app::Application)
    app.toplevel = createwindow(app)
    ctx = PageContext(app, app.toplevel)
    push!(app.toplevel.router, build(app.home, ctx))
    return present!(app.toplevel)
    # set_child!(window, Label("Hello Attrape!"))
    # return present!(window)
end


function run(app::Application)
    init!(app)
    Mousetrap.run!(app.mousetrap)
    return 0
end
