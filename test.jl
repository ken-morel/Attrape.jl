include("./src/Attrape.jl")
import Mousetrap
using .Attrape
import Efus

ROUTER = nothing
const text_reactant = Reactant("Reactive Text")
const slider_value = Reactant(0.0)
const switch_active = Reactant(false)

const home_page = page"""
    Box orient=V margin=10x10
        Label text="Welcome to the Widget Showcase!" halign=:center expand=true
        Label text="Use the navigation on the left to explore the widgets." halign=:center expand=true
"""

const text_page = page"""
    Box orient=V margin=10x10
        Label text="Entry (1-line) and Label, reactively linked:"
        Entry text=text_reactant
        Label text=(text_reactant')
        Label text="TextView (multi-line):"
        TextView text="You can type multiple lines here." size=300x100
"""


const controls_page = page"""
    Box orient=V margin=10x10 expand=true
        Box orient=H margin=5x5
            Label text="Switch:"
            Switch active=switch_active
            Label text="Spinner (reacts to Switch):"
            Spinner active=switch_active
        Box orient=V margin=5x5
            Label text=(slider_value')
            Slider value=slider_value min=0 max=1 step=0.01
            Label text="ProgressBar (reacts to Slider):"
            ProgressBar fraction=(slider_value')
"""

# I am assuming this path exists on a standard Linux system with the Julia icon.
# If not, the user can change it to a valid image path.
const media_page = page"""
    Box orient=V margin=10x10 halign=:center valign=:center expand=true
        Label text="Picture widget:"
"""
#Picture source="/usr/share/icons/hicolor/48x48/apps/julia.png" size="48x48"

navigate_home(_) = push!(ROUTER, home_page)
navigate_text(_) = push!(ROUTER, text_page)
navigate_controls(_) = push!(ROUTER, controls_page)
navigate_media(_) = push!(ROUTER, media_page)

Application("com.julia.widget-showcase") do ctx
    global ROUTER = ctx.window.router
    page"""
        Box orient=H
            Box orient=V size=150x0 margin=5x5
                Button text="Home" onclick=navigate_home
                Button text="Text Widgets" onclick=navigate_text
                Button text="Controls" onclick=navigate_controls
                Button text="Media" onclick=navigate_media
    """
end |> run!
