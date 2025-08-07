include("../src/Attrape.jl")

using .Attrape
using Efus
import Mousetrap

Page = PageBuilder(
    efus"""
    using Attrape

    Frame
    """
) do nmsp::AbstractNamespace, ctx::PageBuildContext, args::NamedTuple
end

function (@main)(::Vector{String})
    app = application(
        "test"; home = PageRoute() do
            Page
        end
    )
    return Attrape.run(app)
end
