using Mousetrap


app = Application("com.example.mousetrap")
connect_signal_activate!(app) do app::Application
    try
        window = Window(app)
        set_child!(window, Label("Hello World!"))
        present!(window)
    catch exception
        printstyled(stderr, "[ERROR] "; bold = true, color = :red)
        printstyled(stderr, "In Mousetrap.main: "; bold = true)
        Base.showerror(stderr, exception, catch_backtrace())
        print(stderr, "\n")
        quit!(app)
    end
    return nothing
end
run!(app)
