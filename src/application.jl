export Application
export run!

const ApplicationInit = FunctionWrapper{Any, Tuple{<:AbstractApplication}}

Base.@kwdef mutable struct Application <: AbstractApplication
    id::String
    init::Function
    toplevel::Union{Window, Nothing} = nothing
    app::Union{Mousetrap.Application, Nothing} = nothing
    Application(init::Function, id::String) = new(id, init, nothing, nothing)
end


function run!(a::Application)
    a.app = Mousetrap.Application(a.id)
    a.toplevel = Window()
    Mousetrap.connect_signal_activate!(a.app) do app::Mousetrap.Application
        try
            mount!(a.toplevel, a)
            page = a.init(getcontext(a.toplevel))
            if page isa Page
                push!(a.toplevel.router, page)
            end
        catch exception
            printstyled(stderr, "[ERROR] "; bold = true, color = :red)
            printstyled(stderr, "In Attrape callback: "; bold = true)
            Base.showerror(stderr, exception, catch_backtrace())
            print(stderr, "\n")
            Mousetrap.quit!(app)
        end
        return nothing
    end
    return Mousetrap.run!(a.app)
end
