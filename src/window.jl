export Window, show, getcontext

Base.@kwdef mutable struct Window <: AttrapeComponent
    const title::MayBeReactive{String} = Reactant("Window")

    router::AbstractRouter = Router()
    catalyst::Catalyst = Catalyst()
    app::Union{AbstractApplication, Nothing} = nothing
    window::Union{Mousetrap.Window, Nothing} = nothing

    const children::Vector{AbstractComponent} = AttrapeComponent[]

    dirty::Dict{Symbol, Any} = Dict()
end

function update!(w::Window)
    isnothing(w.window) && return
    for (k, v) in w.dirty
        if k == :title
            Mousetrap.set_title!(w.window, v)
        end
    end
    return
end

function mount!(w::Window, a::AbstractApplication)
    w.app = a
    w.window = Mousetrap.Window(a.app)
    Mousetrap.set_title!(w.window, resolve(String, w.title))
    Mousetrap.present!(w.window)
    if length(w.children) > 0
        show(w, w.children[1])
    end
    catalyze!(w.catalyst, w.router.current_page) do page
        show(w, page)
    end
    if w.title isa AbstractReactive
        catalyze!(w.catalyst, w.title) do v
            w.dirty[:title] = v
            shaketree(w)
        end
    end
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
