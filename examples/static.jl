include("../src/Attrape.jl")

import Mousetrap
using .Attrape
using Efus

@time const home = StaticPage(
    efuspreeval"""
    using Attrape

    Box orient=v
      Frame label="Signin form" box=v
        Box orient=h
          Label text="Your name: "
          SpinButton
        Box orient=h
          Label text="Your age: "
          SpinButton
          
      """
)

(@main)(_) = run!(application(; home))
