include("../src/Attrape.jl")

import Mousetrap
using Efus: @efuspreeval_str, EReactant, sync!
using .Attrape: run!, application, StaticPage

const value = EReactant{Real}(12)
const valfrac = EReactant{Float32}(12 / 100) # keep in [0, 1]

const home = StaticPage(
    efuspreeval"""
    using Attrape

    Frame label="Scale test" box=v margin=20x30
      Label text="spin"
      SpinButton bind=(value)
      Label text="scale"
      Scale bind=(value)
      Label text="level"
      LevelBar bind=(value)
      Label text="Progress"
      ProgressBar bind=(valfrac) text=true
    """Main # important, specify the module or namespace $value is taken from
)

(@main)(_) = (
    sync!(
        value => v -> v / 100, # convert to [0, 1]
        valfrac => nothing, # valuefrac never updates
    ); # syncing valuefrac to value
    run!(application(; home))
)
