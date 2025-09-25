export PageContext, PageBuilder, build


struct PageContext
    app::AbstractApplication
    window::Window
end

const PageBuilder = FunctionWrapper{Page, Tuple{PageContext}}

function build(p::PageContext, b::PageBuilder)
    return b(p)
end

function Base.push!(p::PageContext, b::PageBuilder; replace::Bool = false)
    return push!(p.window.router, build(p, b); replace)
end
function Base.push!(p::PageContext, b::Page; replace::Bool = false)
    return push!(p.window.router, b; replace)
end

function Base.pop!(p::PageContext)
    return pop!(p.window.router)
end


function mount!(p::Page, w::Window)
    return mount!(p.component, w)
end
