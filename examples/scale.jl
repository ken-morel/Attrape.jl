include("../src/Attrape.jl")

import Mousetrap
using Efus: @efuspreeval_str, EReactant
using .Attrape: run!, application, StaticPage

const value = EReactant{Real}(12)

const home = StaticPage(
    efuspreeval"""
    using Attrape

    Frame label="Scale test" box=v
      Label text="spin"
      SpinButton bind=(value)
      Label text="scale"
      Scale bind=(value)
    """Main # important, specify the module or namespace $value is taken from
)

(@main)(_) = run!(application(; home))
