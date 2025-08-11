include("../src/Attrape.jl")

import Mousetrap
using Efus
using .Attrape

Page = View(
    efusthrow"""
    using Attrape

    Box orient=v
      Label text="Sorry for the latency, <tt>@async</tt> issues"
      for x in 1:15
        Frame box=h
          Label text=("Spinbutton $x")
          SpinButton bind=(val)
      end
    """
) do nmsp::AbstractNamespace, ::PageContext, ::Base.Pairs
    nmsp[:val] = EReactant{Real}(10)
end

function (@main)(::Vector{String})
    return run!(application(home = Page))
end
