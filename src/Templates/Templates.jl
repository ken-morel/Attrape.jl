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

const COMMON_ARGS = Pair{Symbol, Type}[
    :margin => Efus.EEdgeInsets{Number, nothing},
    :expand => Efus.EOrient,
]

function setmargin!(w::Widget, m::EEdgeInsets)
    set_margin_bottom!(w, m.bottom)
    set_margin_top!(w, m.top)
    set_margin_start!(w, m.left)
    set_margin_end!(w, m.right)
    return
end
function setexpand!(w::Widget, e::EOrient)
    v = e ∈ [:both, :vertical]
    h = e ∈ [:both, :horizontal]
    set_expand_vertically!(w, v)
    return set_expand_horizontally!(w, h)
end

function processcommonargs!(c::AttrapeComponent, w::Mousetrap.Widget)
    c[:margin] isa EEdgeInsets && setmargin!(w, c[:margin])
    c[:expand] isa EOrient && setexpand!(w, c[:expand])
    return
end
function updateutil!(fn::Function, c::AttrapeComponent)
    isnothing(c.mount) && return
    w = c.mount.widget
    for name in c.dirty
        if name === :margin
            c[:margin] isa EEdgeInsets && setmargin!(w, c[:margin])
        elseif name == :expand
            c[:expand] isa EOrient && setexpand!(w, c[:expand])
        else
            ismissing(fn(name, c[name])) && @warn(
                "Changed immutable attribute",
                name,
                " of component of type",
                typeof(c),
            )
        end
    end
    return
end
function Efus.update!(c::AttrapeComponent)
    return updateutil!(c) do _, _
        missing
    end
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
include("textview.jl")
include("dropdown.jl")
include("expander.jl")
include("adjustment.jl")
include("gridview.jl")

function eregister()
    registertemplate.(
        (:Attrape,), [
            frame,
            label,
            box,
            flowBox,
            separator,
            imageDisplay,
            button,
            toggleButton,
            checkbutton,
            switch,
            spinButton,
            scale,
            levelBar,
            progressBar,
            spinner,
            entry,
            textView,
            dropDown,
            expander,
            adjustment,
            gridView,
        ]
    )
    return
end

function __init__()
    eregister()
    return
end

end
