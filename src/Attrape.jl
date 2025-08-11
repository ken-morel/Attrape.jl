module Attrape

using Atak
using Efus
using Atak.Store

import Mousetrap

export application, Page, PageContext, PageRoute, route, View, run!, StaticPage

abstract type AbstractWindow end

include("bridge.jl")
include("page.jl")
const Page = AbstractPage
include("routes.jl")
include("window.jl")

include("application.jl")

include("Templates/Templates.jl")

function __init__()
    return
end


end
