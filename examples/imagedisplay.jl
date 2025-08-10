include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const Page = Attrape.view(
    efus"""
    using Attrape

    Frame label="Image test" box=v
      ImageDisplay path=(path)
    """
) do nmsp, ctx, args
    nmsp[:path] = joinpath(@__DIR__, "nadia-logo.jpg")

end
function (@main)(::Vector{String})
    app = application(
        "com.test"; home = Page
    )
    return Attrape.run(app)
end
