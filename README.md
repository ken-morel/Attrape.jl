# Attrape

Well, this is [Attrape] A julia module which uses:

- Mousetrap: The gtk based ui toolkit
- Atak: The utilities for making apps
- Efus: The component language.

Attrape defines converters, components and other usefull things for easily crafting a Mousetrap application in julia.
since Attrape does mostly creating bindings for Efus.jl, what I did not really not document... at all. The easiest way to know how to use it is to read through the examples I aimed at showing Efus and Attrape features.

## Efus

I did not document efus, so I will do some here.
[Efus.jl] is a language and tools for creating templates, and calling them using Efus language
(note that efus language is not markup, but a set of instructions for creating ui components).

## Installing Attrape

Attrape is still in development, but I would love having testers :D. You can install Attrape
from the github repository.
Firstly [install mousetrap](#)

```julia
using Pkg
Pkg.add("https://github.com/ken-morel/Efus.jl")
Pkg.add("https://github.com/ken-morel/Atak.jl")
Pkg.add("https://github.com/ken-morel/Attrape.jl")
```

## Using Attrape

You do so using Efus, example creating a basic component(the efus string is evaluated and converted to component at compile time).

```julia
import Attrape # import it to register efus components
using Mousetrap
using Efus: @efuspreeval_str

label = "Your age: "

const form = efuspreeval"""
  using Attrape # import Attrape components registered earlier to namespace

  Frame margin=10x10 box=v # vbox
    Box orient=h
      Label text=(label)
      SpinButton
"""Main # specify module to be evaluated in
main() do app::Application
  win = Window(app)
  frame = mount!(form).widget
  set_child!(win, frame)
  present!(win)
  return
end

```

You may also use Attrape for managing the window and application for you.

```julia
using Attrape
using Efus
import Mousetrap # always do this please

const Home = View(
  efusthow"""
    Frame margin=50x50 label="Hello, welcome" box=h
      Label="Welcome, click the button to choose toggles"
      Button clicked=(gtscales)

  """
) do nmsp, # namespace inwhich code will be evaluated
    ctx, # the pagecontext instance holding window and app
    args # keyword arguments passed using Home(...; foo=bar)

  nmsp[:gtscales] = (_) -> push!(ctx, Scales)
end

const val = EReactant(10)
const Scales = StaticPage(
  efuspreeval"""
    Frame label="Here are a few scales"
      Box orient=v
        SpinButtton range=(1:2:100) bind=(val)
        ProgressBar bind=(val)
  """
)

(@main)(_) = run!(application("com.test";home=Home))
```

Well, I'm sure somebody can now know what it's.
