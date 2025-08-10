include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const Page = Attrape.view(
    efus"""
    using Attrape

    Frame label="Toggle button test" box=v
      ToggleButton bind=(btn)
    """
) do nmsp, ctx, args
    nmsp[:btn] = EReactant(false)
    subscribe!(nmsp[:btn], nothing) do ::Nothing, v::Bool
        println("current value $v")
        return
    end
end
function (@main)(::Vector{String})
    app = application(
        "com.test"; home = Page
    )
    return Attrape.run(app)
end
