export Window, show, getcontext

mutable struct Window <: AttrapeComponent
    router::AbstractRouter
    catalyst::Catalyst
    app::Union{AbstractApplication, Nothing}
    window::Union{Mousetrap.Window, Nothing}

    function Window()
        win = new(Router(), Catalyst(), nothing, nothing)
        catalyze!(win.catalyst, win.router.current_page) do page
            show(win, page)
        end
        return win
    end
end

function mount!(w::Window, a::AbstractApplication)
    w.app = a
    w.window = Mousetrap.Window(a.app)
    Mousetrap.present!(w.window)
    return w.window
end

function show(w::Window, p::Page)
    widget = mount!(p, w)
    Mousetrap.set_child!(w.window, widget)
    return widget
end

function getcontext(w::Window)
    return PageContext(w.app, w)
end
