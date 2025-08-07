Base.@kwdef struct Window <: AbstractWindow
    app::AbstractApplication
    mousetrap::Mousetrap.Window
    router::Router
end


function createwindow(app::AbstractApplication)
    route = router(app.home)
    win = Window(app, Mousetrap.Window(app.mousetrap), route)
    # update!(win)
    println("subscribing")
    Efus.subscribe!(route, nothing) do _
        println("updated router, updating window")
        update!(win)
    end
    return win
end

function update!(win::Window)
    ctx = PageBuildContext(win.app, win)
    page = getcurrentpage(win.router)
    return if isnothing(page)
        Mousetrap.set_child!(win.mousetrap, nothing)
    else
        widget = render(page, ctx)
        Mousetrap.set_child!(win.mousetrap, widget)
    end
end

present!(w::Window) = Mousetrap.present!(w.mousetrap)
