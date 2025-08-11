import Mousetrap

(@main)(_) = let app = Mousetrap.Application("com.example")
    Mousetrap.connect_signal_activate!(app) do app::Mousetrap.Application
        win = Mousetrap.Window(app)
        container = Mousetrap.vbox(
            Mousetrap.hbox(
                Mousetrap.Label("Name: "),
                Mousetrap.Entry(),
            ),
            Mousetrap.hbox(
                Mousetrap.Label("Password: "),
                Mousetrap.Entry(),
            )
        ) |> Mousetrap.Frame
        Mousetrap.set_child!(win, container)
        Mousetrap.present!(win)
    end
    return Mousetrap.run!(app)
end
