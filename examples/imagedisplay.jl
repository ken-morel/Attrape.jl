include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const Page = View(
    efusthrow"""
    using Attrape

    Frame label="Image test" box=v
      ImageDisplay path=(path)
    """
) do nmsp, ctx, args
    nmsp[:path] = joinpath(@__DIR__, "nadia-logo.jpg")
end
function (@main)(::Vector{String})
    return run!(
        application(
            "com.test"; home = Page
        )
    )
end
