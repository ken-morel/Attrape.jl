include("../src/Attrape.jl")

import Mousetrap
using .Attrape
using Efus


const home = StaticPage(
    efuspreeval"""
    using Attrape

    Frame box=v label="Textarea"
      TextView text="Hello world"
    """
)

(@main)(_) = run!(application(; home))
