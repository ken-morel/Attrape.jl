include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const Page = View(
    efusthrow"""
    using Attrape

    Frame label="Toggle button test" box=v
      Switch bind=(btn)
    """
) do nmsp, ctx, args
    nmsp[:btn] = EReactant(false)
    subscribe!(nmsp[:btn], nothing) do ::Nothing, v::Bool
        println("current switch value $v")
        return
    end
end
function (@main)(::Vector{String})
    return run!(
        application(
            home = Page
        )
    )
end
