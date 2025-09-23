include("./src/Attrape.jl")
import Mousetrap
using .Attrape
import Efus

const LabelText = Reactant("Hello world!")

function callback(_)
    return setvalue!(LabelText, getvalue(LabelText) * "!")
end

const Home = PageBuilder() do ctx
    efus_build"""
      Frame box=V
        Label text=(LabelText')
        Label text=LabelText
        Button text="Click me" onclick=(callback)
    """ |> Page
end

Application("com.julia.mousetrap") do ctx
    return Home(ctx)
end |> run!
