Base.@kwdef struct Window <: AbstractWindow
    app::Atak.Application
    mousetrap::Mousetrap.Window
    router::Router
end


function createwindow(app::Atak.Application)
    r = router()
    win = Window(app, Mousetrap.Window(app.mousetrap), r)
    Efus.subscribe!(r, nothing) do _
        update!(win)
    end

    return win
end

createwindow(f::Function, a::Atak.Application) = let w = createwindow(a)
    push!(w.router, f(PageContext(a, w)))
    w
end

function update!(win::Window)
    page = getcurrentpage(win.router)
    return if isnothing(page)
        Mousetrap.set_child!(win.mousetrap, nothing)
    else
        widget = render(page)
        Mousetrap.set_child!(win.mousetrap, widget)
    end
end

present!(w::Window) = Mousetrap.present!(w.mousetrap)
