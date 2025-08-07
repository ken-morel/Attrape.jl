include("../src/Attrape.jl")
using .Attrape
import Mousetrap

function create_application()
    return application("cm.rbs.engon.attrape")
end

function (@main)(::Vector{String})
    app = create_application()
    return Attrape.run(app)
end
