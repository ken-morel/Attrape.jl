module Attrape
import Mousetrap
import Efus: mount!, @efus_str, @efus_build_str
using Efus
using Atak
using FunctionWrappers: FunctionWrapper

export mount!

export @efus_str, @efus_build_str

abstract type AttrapeComponent <: Efus.AbstractComponent end
abstract type AbstractApplication <: Atak.AbstractApplication end
abstract type AbstractRouter end

include("./router.jl")
include("./window.jl")
include("./page.jl")
include("./application.jl")

include("./widgets/widgets.jl")

end
