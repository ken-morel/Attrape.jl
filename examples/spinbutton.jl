include("../src/Attrape.jl")

import Mousetrap
using Efus
using .Attrape

Page = View(
    efusthrow"""
    using Attrape

    Box orient=v
      Label text=("" *
      "Sorry for the latency, \
      <tt>@async</tt> and <tt>@spawn</tt> \
      did not work yet<small>...</small>"
      )
      for x in 1:20
        Frame box=h
          Label text=("Spinbutton $x")
          SpinButton bind=(val)
      end
    """
) do nmsp::AbstractNamespace, ::PageContext, ::Base.Pairs
    nmsp[:val] = EReactant{Real}(10)
end

function (@main)(::Vector{String})
    return run!(application("com.test", home = Page))
end
