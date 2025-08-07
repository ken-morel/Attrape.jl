mutable struct AppParams
end

Base.@kwdef mutable struct Application <: AbstractApplication
    id::String
    store::Union{Namespace, Nothing} = nothing
    mousetrap::Mousetrap.Application
    toplevel::Union{Window, Nothing} = nothing
    home::Union{PageRoute, AbstractPage}
end

function application(id::String; home::Union{PageRoute, AbstractPage})
    return Application(;
        id, home,
        mousetrap = Mousetrap.Application(id),
    )
end

function init!(app::Application)
    Mousetrap.connect_signal_activate!(app.mousetrap) do ::Mousetrap.Application
        try
            mount!(app)
        catch exception
            printstyled(stderr, "[ERROR] "; bold = true, color = :red)
            printstyled(stderr, "In Attrape: "; bold = true)
            Base.showerror(stderr, exception, catch_backtrace())
            print(stderr, "\n")
            Mousetrap.quit!(app)
        end
        return nothing
    end
    return
end

function mount!(app::Application)
    app.toplevel = createwindow(app)
    push!(app.toplevel.router, app.home)
    println("just pushed")
    return present!(app.toplevel)
    # set_child!(window, Label("Hello Attrape!"))
    # return present!(window)
end


function run(app::Application)
    init!(app)
    Mousetrap.run!(app.mousetrap)
    return 0
end
