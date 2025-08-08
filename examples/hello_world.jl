include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

const HelloWorldView = Attrape.view(
    efus"""
    using Attrape

    Frame label="A beautiful frame" box=v
      Label text="Hello world"
      Label text="Hello world"
    """
) do nmsp, ctx, args
end
function (@main)(::Vector{String})
    app = application(
        "com.test"; home = HelloWorldView
    )
    return Attrape.run(app)
end
