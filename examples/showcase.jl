using Attrape

ROUTER::Union{Router, Nothing} = nothing
const text_reactant = Reactant("Reactive Text")
const slider_value = Reactant{Float32}(0.0)
const switch_active = Reactant(false)
const text_view = Reactant("You can type multiple lines here:")

navigate_home(_) = push!(ROUTER, home_page)
navigate_text(_) = push!(ROUTER, text_page)
navigate_controls(_) = push!(ROUTER, controls_page)


const Navigation = () -> efus"""
Box orient=OH margin=10x10
   Button text="Home" onclick=navigate_home
   Button text="Text Widgets" onclick=navigate_text
   Button text="Controls" onclick=navigate_controls
"""

const home_page = page"""
    Box orient=OV margin=10x10
        Navigation
        Label text="Welcome to the Widget Showcase!" halign=AC expand=true
        Label text="Use the navigation on the left to explore the widgets." halign=AC expand=true
"""

const text_page = page"""
    Box orient=OV margin=10x10
        Navigation
        Label text="Entry (1-line) and Label, reactively linked:"
        Entry text=text_reactant
        Label text=("Computed: " * text_reactant')
        Label text="TextView (multi-line):"
        TextView text=text_view size=300x100
        TextView text=(text_view' * " and here too, but without updates :-(") size=300x100
"""


const controls_page = page"""
    Box orient=OV margin=10x10 expand=true
        Navigation
        Box orient=OH margin=5x5
            Label text="Switch:"
            Switch active=switch_active
            Label text="Spinner (reacts to Switch):"
            Spinner active=switch_active
        Box orient=OV margin=5x5
            Label text=(string(slider_value'))
            Slider value=slider_value range=(0.0:0.1:1.0)
            Label text="ProgressBar (reacts to Slider):"
            ProgressBar fraction=slider_value
"""

Application("com.julia.widget-showcase") do ctx
    global ROUTER = ctx.window.router
    setvalue!(ctx.window.title, "Attrape showcase")
    page"""
        Box orient=OH
            Navigation
            Box orient=OV size=150x0 margin=5x5
                Button text="Home" onclick=navigate_home
                Button text="Text Widgets" onclick=navigate_text
                Button text="Controls" onclick=navigate_controls
    """
end |> run!
