> [!WARNING]
> I stoped working on this in preference to Gtak.jl.
> this module is not more compatible with efus due to 
> ongoing ameliorations(but it takes not much to do
> though)
# Attrape.jl

In short, Efus.jl defines a simple language, and Attrape.jl
defines components basing on Mousetrap.jl widgets.
It also provides you abit more to help you combine
The power of Mousetrap.jl and Efus.jl.
If you have not yet, you could have a look at
[Efus.jl](https://github.com/ken-morel/efus.jl) and
[Mousetrap.jl](https://gibhub.com/clemapfel/moustrap.jl)

## Application

Attrape wraps arround the actual mousetrap application
where we have an Application, which stores the Mousetrap app,
Windows, like the application's `.toplevel`, and
each window has a `.router`, for navigating and displaying different
pages.

```julia
(@main)(_) = Application("com.julia.widget-showcase") do ctx
    setvalue!(ctx.window.title, "Attrape showcase")
end |> run!
```

That's like a short way of doing that.
The ctx, which will see in several other parts is
the window context, containing `.window` and `.app`
attributes.

Attrape creates a first window for you, which you can
access via the ctx.window.
The window initializer function you have seen earlier can also
return a page, if so it will be displayed on the window
and pushed to the router.

## Components

Attrape defines components which wrap on mousetrap widgets
Since they are just structs, you can always call them
directly, or view their help.

```julia
using Attrape # Utmost important.

component = efus"""Label text="free!" """
```

## Router

A router stores a stack of pages,
it supports `push!`, `pop!` methods which almost immediately
show on the window. The current page is stored
in a reactant, and the history in a vector.

## Page

A page simply contains a component which can be
displayed on a window, or placed in an actual mousetrap
widget. Like if you want to display a component in
a frame, you will wrap it in a page, and call `mount!(page, widget)`
and `unmount!` to emit the destroy signal.

```julia
# You can either create a page from a component
const Home = Page(@efus_build"Frame padding=3x2")

# Or use the page macro
# ctx is already defined
const Widgets = page"Frame"
```

## Page Builders

A pagebuilder is a Function wrapper which takes a PageContext(containint
window and app, like in the app init's funciton)
and returns a Page.

```julia
# either call it manually
const Builder = PageBuilder() do ctx
  page"Frame"
end

# or use the macro
# It creates a closure where ctx is defined
const Builder = pagebuilder"
  Label text=(ctx.window.title)
"
```

## Composite components

One of the main thing with components, is that
they can be composed to create bigger ones.
You can use the Composite structure, a callable
structure which passes all it's keyword arguments.
since @efus_str returns a closure, you can use it directly
for no argument components.

```julia
# julia --project=. -O0 --compile=min test.jl

using Attrape

ROUTER::Union{Router, Nothing} = nothing
const text_reactant = Reactant("Reactive Text")
const slider_value = Reactant{Float32}(0.0)
const switch_active = Reactant(false)
const text_view = Reactant("You can type multiple lines here:")

navigate_home(_) = push!(ROUTER, home_page)
navigate_text(_) = push!(ROUTER, text_page)
navigate_controls(_) = push!(ROUTER, controls_page)


const Navigation = Composite(
    efus"""
    Box orient=OH margin=10x10
       Button text="Home" onclick=navigate_home
       Button text="Text Widgets" onclick=navigate_text
       Button text="Controls" onclick=navigate_controls
    """
)

const home_page = page"""
    Box orient=OV margin=10x10
        Navigation
        Label text="Welcome to the Widget Showcase!" halign=AC expand=true
        Label text="Use the navigation on the left to explore the widgets." halign=AC expand=true
"""

const text_page = page"""
    Box orient=OV margin=10x10
        Navigation
        Label text="Entry (1-line) and Label, reactively linked:"
        Entry text=text_reactant
        Label text=("Computed: " * text_reactant')
        Label text="TextView (multi-line):"
        TextView text=text_view size=300x100
        TextView text=(text_view' * " and here too, but without updates :-(") size=300x100
"""


const controls_page = page"""
    Box orient=OV margin=10x10 expand=true
        Navigation
        Box orient=OH margin=5x5
            Label text="Switch:"
            Switch active=switch_active
            Label text="Spinner (reacts to Switch):"
            Spinner active=switch_active
        Box orient=OV margin=5x5
            Label text=(string(slider_value'))
            Slider value=slider_value range=(0.0:0.1:1.0)
            Label text="ProgressBar (reacts to Slider):"
            ProgressBar fraction=slider_value
"""

Application("com.julia.widget-showcase") do ctx
    global ROUTER = ctx.window.router
    setvalue!(ctx.window.title, "Attrape showcase")
    page"""
        println
        Box orient=OH
            Box orient=OV size=150x0 margin=5x5
                Button text="Home" onclick=navigate_home
                Button text="Text Widgets" onclick=navigate_text
                Button text="Controls" onclick=navigate_controls
    """
end |> run!

```

Have fun!
