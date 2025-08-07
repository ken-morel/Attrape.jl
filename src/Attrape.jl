module Attrape

using Atak
using Efus
using Atak.Store

import Mousetrap

export application, run


abstract type AbstractApplication end

abstract type AbstractWindow end
include("page.jl")
include("routes.jl")
include("window.jl")

include("application.jl")


end
