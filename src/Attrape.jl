module Attrape

using Atak
using Efus
using Atak.Store

import Mousetrap

export application, run
export BuilderPage, PageBuildContext, PageBuilder, PageRoute


abstract type AbstractApplication end

abstract type AbstractWindow end
include("page.jl")
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
