include("./src/Attrape.jl")
import Mousetrap
using .Attrape
import Efus

const ROUTER = Router()
const text_reactant = Reactant("Reactive Text")
const slider_value = Reactant(0.0)
const switch_active = Reactant(false)

const home_page = Page(page"""
    Box box=V margin="10 10"
        Label text="Welcome to the Widget Showcase!" halign=center expand=true
        Label text="Use the navigation on the left to explore the widgets." halign=center expand=true
""")

const text_page = Page(page"""
    Box box=V margin="10 10"
        Label text="Entry (1-line) and Label, reactively linked:"
        Entry text=text_reactant
        Label text=(text_reactant')
        Label text="TextView (multi-line):"
        TextView text="You can type multiple lines here." size="300x100"
""")

const controls_page = Page(page"""
    Box box=V margin="10 10" expand=true
        Box box=H margin="5 5"
            Label text="Switch:"
            Switch active=switch_active
            Label text="Spinner (reacts to Switch):"
            Spinner active=switch_active
        Box box=V margin="5 5"
            Label text=(slider_value')
            Slider value=slider_value min=0 max=1 step=0.01
            Label text="ProgressBar (reacts to Slider):"
            ProgressBar fraction=(slider_value')
""")

# I am assuming this path exists on a standard Linux system with the Julia icon.
# If not, the user can change it to a valid image path.
const media_page = Page(page"""
    Box box=V margin="10 10" halign=center valign=center expand=true
        Label text="Picture widget:"
        Picture source="/usr/share/icons/hicolor/48x48/apps/julia.png" size="48x48"
""")

navigate_home(_) = push!(ROUTER, home_page)
navigate_text(_) = push!(ROUTER, text_page)
navigate_controls(_) = push!(ROUTER, controls_page)
navigate_media(_) = push!(ROUTER, media_page)

Application("com.julia.widget-showcase") do ctx
    page"""
        Box box=H
            Box box=V size="150x0" margin="5 5"
                Button text="Home" onclick=navigate_home
                Button text="Text Widgets" onclick=navigate_text
                Button text="Controls" onclick=navigate_controls
                Button text="Media" onclick=navigate_media
            Reactor(ROUTER.current_page) do page_or_nothing
                if isnothing(page_or_nothing)
                    return page"Label text='Select a page' halign=center valign=center expand=true"
                else
                    return page_or_nothing.component
                end
            end
    """
end |> run!
