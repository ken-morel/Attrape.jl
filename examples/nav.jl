include("../src/Attrape.jl")
using .Attrape
import Mousetrap


Page1 = Attrape.RawBuilder() do ctx, args
    button = "Hello world 1(click to go to next page)" |> Mousetrap.Label |> Mousetrap.Button
    Mousetrap.connect_signal_clicked!(button) do _
        Attrape.push!(ctx, Page2; replace = true)
        return
    end
    return button |> Mousetrap.Frame
end
Page2 = Attrape.RawBuilder() do ctx, args
    button = "Hello again world 2(click to go to previous page)" |> Mousetrap.Label |> Mousetrap.Button
    Mousetrap.connect_signal_clicked!(button) do _
        Attrape.push!(ctx, Page1; replace = true)
        return
    end
    return button |> Mousetrap.Frame
end


function create_application()
    return application(home = Page1)
end

function (@main)(::Vector{String})
    return run!(create_application())
end
