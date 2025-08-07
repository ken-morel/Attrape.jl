mutable struct AppParams
end

Base.@kwdef mutable struct Application
    id::String
    store::Union{Namespace, Nothing}
    mousetrap::Mousetrap.Application
end

function application(id::String)
    app = Application(;
        id, store = nothing,
        mousetrap = Mousetrap.Application(id),
    )
    return app
end

function init!(app::Application)
    connect_signal_activate!(app.mousetrap) do mousetrap::Mousetrap.Application
        try
            mount!(app)
        catch exception
            printstyled(stderr, "[ERROR] "; bold = true, color = :red)
            printstyled(stderr, "In Attrape: "; bold = true)
            Base.showerror(stderr, exception, catch_backtrace())
            print(stderr, "\n")
            quit!(app)
        end
        return nothing
    end
    return
end

function mount!(app::Application)
    window = Window(app.mousetrap)
    set_child!(window, Label("Hello Attrape!"))
    return present!(window)
end


function run(app::Application)
    init!(app)
    run!(app.mousetrap)
    return 0
end
