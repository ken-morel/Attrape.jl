module Attrape
import Mousetrap
import Efus: mount!, unmount!, remount!, @efus_str
using Efus
using Atak
using Atak.Store
using FunctionWrappers: FunctionWrapper
using BaseDirs

export mount!
export Mousetrap
export AbstractComponent, AbstractReactive

export @efus_str

export Reactant, Reactor, catalyze!, inhibit!, Catalyst

export getvalue, setvalue!

abstract type AttrapeComponent <: Efus.AbstractComponent end
abstract type AbstractApplication <: Atak.AbstractApplication end
abstract type AbstractRouter end

include("./bridge.jl")
include("./router.jl")
include("./window.jl")
include("./page.jl")
include("./application.jl")
include("./store.jl")

include("./widgets/widgets.jl")

include("./macros.jl")

end
