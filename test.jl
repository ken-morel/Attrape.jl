include("./src/Attrape.jl")
import Mousetrap
using .Attrape
import Efus

const LabelText = Reactant("Hello world!")

function callback(_)
    return setvalue!(LabelText, getvalue(LabelText) * "!")
end


Application("com.julia.mousetrap") do ctx
    page"""
      Frame box=V
        Label text=(LabelText')
        Label text=LabelText
        Button text="Click me" onclick=(callback)
    """
end |> run!
