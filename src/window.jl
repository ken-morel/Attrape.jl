Base.@kwdef struct Window <: AbstractWindow
    app::AbstractApplication
    mousetrap::Mousetrap.Window
    router::Router
end


function createwindow(app::AbstractApplication)
    r = router()
    win = Window(app, Mousetrap.Window(app.mousetrap), r)
    Efus.subscribe!(r, nothing) do _
        update!(win)
    end

    if !isnothing(app.home)
        ctx = PageContext(win.app, win)
        page = build(app.home, ctx)
        push!(r, page; replace = true)
    else
        update!(win)
    end

    return win
end

function update!(win::Window)
    ctx = PageContext(win.app, win)
    page = getcurrentpage(win.router)
    return if isnothing(page)
        Mousetrap.set_child!(win.mousetrap, nothing)
    else
        widget = render(page)
        Mousetrap.set_child!(win.mousetrap, widget)
    end
end

present!(w::Window) = Mousetrap.present!(w.mousetrap)
