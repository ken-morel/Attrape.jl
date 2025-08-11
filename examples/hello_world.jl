include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const HelloWorldView = View(
    efusthrow"""
    using Attrape

    Frame label="A beautiful frame" box=v
      Label text="Hello world"
      Label text="Hello world"
    """
) do nmsp, ctx, args
end
function (@main)(::Vector{String})
    return run!(
        application(
            home = HelloWorldView
        )
    )
end
