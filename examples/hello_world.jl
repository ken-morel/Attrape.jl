include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const HelloWorldView = View(
    efus"""
    using Attrape

    Frame
    """
) do nmsp, ctx, args
end
function (@main)(::Vector{String})
    app = application(
        "com.test"; home = HelloWorldView
    )
    return Attrape.run(app)
end
