include("../src/Attrape.jl")

import Mousetrap
using .Attrape
using Efus

const spinning = EReactant(true)

function togglespin(_)
    Efus.update!(!, spinning) # negate the spinning value
    @time Efus.notify(spinning) # notify so that button updates
    return # make sure the callback returns nothing
end


run!(
    application(;
        home = StaticPage(
            efuspreeval"""
            using Attrape

            Frame box=v margin=50
              Spinner spinning=(spinning)
              # when passing an *unexpected* reactant, component subscribes to it
              Button clicked=(togglespin)
            """Main # don't forget, when using preeval
        )
    )
)
