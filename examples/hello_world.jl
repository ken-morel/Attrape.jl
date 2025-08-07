include("../src/Attrape.jl")
using .Attrape
import Mousetrap

Home = Attrape.BuilderPage() do ctx
    return Mousetrap.Button()
end


function create_application()
    return application("cm.rbs.engon.attrape"; home = Home)
end

function (@main)(::Vector{String})
    return Attrape.run(create_application())
end
