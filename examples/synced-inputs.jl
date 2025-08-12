include("../src/Attrape.jl")
import Mousetrap
using .Attrape
using Efus

const entry = EReactant("unset")
const progress = EReactant{Float32}(0.0)
const scale = EReactant{Float32}(0.0)
const spin = EReactant{Float32}(0.0)

syncall!(
    nothing,
    scale,

    (
        b -> "Value: " * string(b),
        entry,
        e -> try
            println(e)
            parse(Float32, e[8:end])
        catch
            zero(Float32)
        end,
    ),
    (b -> b / 100, progress),
    (b -> b * 10, spin, s -> s / 10),

)

const home = StaticPage(
    efuspreeval"""
    using Attrape

    Frame margin=30x30 box=v
      Label text="Entry"
      Entry bind=(entry)

      Label text="Progress"
      ProgressBar bind=(progress)

      Label text="Scale"
      Scale bind=(scale)

      Label text="Spin <small>(x10)</small>"
      SpinButton bind=(spin) range=(0:1000)

      """Main
)

(@main)(_) = run!(application(; home))
