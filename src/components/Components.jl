module Components
using ..Attrape
using Efus

abstract type AttrapeComponent <: Efus.AbstractComponent end

include("./window.jl")

end
