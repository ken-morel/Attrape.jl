module Attrape

using Atak
using Efus
using Atak.Store

import Mousetrap

export application, run, view, PageContext, PageRoute, route


abstract type AbstractApplication end

abstract type AbstractWindow end
include("bridge.jl")
include("page.jl")
const Page = AbstractPage
include("routes.jl")
include("window.jl")

include("application.jl")

include("template.jl")
include("templates.jl")

function __init__()
    eregister()
    return
end


end
