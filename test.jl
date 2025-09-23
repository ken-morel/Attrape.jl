include("./src/Attrape.jl")
import Mousetrap
using .Attrape

const Home = PageBuilder() do ctx
    efus_build"""
      Label text="YOu did it!"
    """ |> Page
end

Application("com.julia.mousetrap") do ctx
    return Home(ctx)
end |> run!
