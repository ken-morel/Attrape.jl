include("../src/Attrape.jl")
using .Attrape
import Mousetrap


Page1 = Attrape.BuilderPage() do ctx
    button = "Hello world 1(click to go to next page)" |> Mousetrap.Label |> Mousetrap.Button
    Mousetrap.connect_signal_clicked!(button) do _
        push!(ctx, Page2; replace = true)
        return
    end
    return button |> Mousetrap.Frame
end
Page2 = Attrape.BuilderPage() do ctx
    button = "Hello again world 2(click to go to previous page)" |> Mousetrap.Label |> Mousetrap.Button
    Mousetrap.connect_signal_clicked!(button) do _
        push!(ctx, Page1; replace = true)
        return
    end
    return button |> Mousetrap.Frame
end


function create_application()
    return application("cm.rbs.engon.attrape"; home = Page1)
end

function (@main)(::Vector{String})
    return Attrape.run(create_application())
end
