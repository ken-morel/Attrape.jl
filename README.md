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
All you need is to define a function which
returns a component, and pass the children
if any to a child.

When doing this the inner components will
have access to the function scope(of course), but
the function which returned the component, even
if it is called via efus code, simply won't count.
In the component tree.

```julia
Navigation = (;login=true) -> efus"""
  Box
    Button text="Home"
    if login
      Button text="Repositories"
    end
"""

Layout = (;login=true,children = []) -> efus"""
  Box orient=OH
    Nagivation login=login
    Box orient=OV children=children
"""
```
