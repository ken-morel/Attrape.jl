module Templates

using Efus
using Mousetrap


abstract type AttrapeBackend <: Efus.TemplateBackend end
abstract type AttrapeMount <: Efus.AbstractMount end

const AttrapeComponent = Efus.Component{<:AttrapeBackend}

struct SimpleMount <: AttrapeMount
    widget::Mousetrap.Widget
    outlet::Mousetrap.Widget
    SimpleMount(w::Mousetrap.Widget) = new(w, w)
    SimpleMount(w::Mousetrap.Widget, o::Mousetrap.Widget) = new(w, o)
end

mutable struct SimpleSyncingMount <: AttrapeMount
    const widget::Mousetrap.Widget
    const outlet::Mousetrap.Widget
    sync::Int8
    SimpleSyncingMount(w::Mousetrap.Widget) = new(w, w, zero(Int8))
    SimpleSyncingMount(w::Mousetrap.Widget, o::Mousetrap.Widget) = new(w, o, zero(Int8))
end

"""
    function update!(fn::Function, m::SimpleSyncingMount, s::_UpdateSide)

This permits update on both side to occur, even several updates in the same
direction simultaneously, but not both sides at the same time.
`attrape` tells if it is attrape side updating mousetrap or opposite else.
"""
function halfduplex!(fn::Function, m::SimpleSyncingMount, attrape::Bool)  # attrape => true, mousetrap => false
    if attrape
        m.sync < 0 && return # othr side updating
        m.sync += 1
        try
            fn()
        catch e
            errorincallback(e)
        finally
            m.sync -= 1
        end
    else
        m.sync > 0 && return # othr side updating
        m.sync -= 1
        try
            fn()
        catch e
            errorincallback(e)
        finally
            m.sync += 1
        end
    end
    return
end

const COMMON_ARGS = []

function processcommonargs!(::AttrapeComponent, ::Mousetrap.Widget)
end

function childgeometry!(parent::AttrapeComponent, child::AttrapeComponent)
    isnothing(parent.mount) && return
    isnothing(child.mount) && return
    Mousetrap.push_back!(parent.mount.widget, child.mount.widget)
    return
end

function errorincallback(e::Exception)
    printstyled(stderr, "[ERROR] "; bold = true, color = :red)
    printstyled(stderr, "In Attrape callback: "; bold = true)
    Base.showerror(stderr, e, catch_backtrace())
    print(stderr, "\n")
    return

end


include("frame.jl")
include("label.jl")
include("box.jl")
include("flowbox.jl")
include("separator.jl")
include("imagedisplay.jl")
include("button.jl")
include("togglebutton.jl")
include("checkbutton.jl")
include("switch.jl")
include("spinbutton.jl")
include("scale.jl")
include("levelbar.jl")
include("progressbar.jl")
include("spinner.jl")
include("entry.jl")

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
            Scale,
            LevelBar,
            ProgressBar,
            Spinner,
            Entry,
        ]
    )
    return
end

function __init__()
    eregister()
    return
end

end
