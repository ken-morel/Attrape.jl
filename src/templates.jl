include("templates/frame.jl")
include("templates/label.jl")
include("templates/box.jl")
include("templates/flowbox.jl")
include("templates/separator.jl")
include("templates/imagedisplay.jl")
include("templates/button.jl")
include("templates/togglebutton.jl")
include("templates/checkbutton.jl")
include("templates/switch.jl")
include("templates/spinbutton.jl")

function eregister()
    registertemplate.(
        (:Attrape,), [
            Frame,
            Label,
            Box,
            FlowBox,
            Separator,
            ImageDisplay,
            Button,
            ToggleButton,
            CheckButton,
            Switch,
            SpinButton,
        ]
    )
    return
end
