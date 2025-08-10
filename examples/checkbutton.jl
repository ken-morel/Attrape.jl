include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const Page = View(
    efusthrow"""
    using Attrape

    Frame label="Toggle button test" box=v
      CheckButton bind=(btn)
    """
) do nmsp, ctx, args
    nmsp[:btn] = EReactant(Mousetrap.CHECK_BUTTON_STATE_INCONSISTENT)
    subscribe!(nmsp[:btn], nothing) do ::Nothing, v::Mousetrap.CheckButtonState
        println("current value $v")
        v !== Mousetrap.CHECK_BUTTON_STATE_ACTIVE && notify!(nmsp[:btn], Mousetrap.CHECK_BUTTON_STATE_ACTIVE)
        return
    end
end
function (@main)(::Vector{String})
    return run!(
        application(
            "com.test"; home = Page
        )
    )
end
