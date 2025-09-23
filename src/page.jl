export PageContext, PageBuilder, build


struct PageContext
    app::AbstractApplication
    window::Window
end

const PageBuilder = FunctionWrapper{Page, Tuple{PageContext}}

function build(p::PageContext, b::PageBuilder)
    return b(p)
end
function Base.push!(p::PageContext, b::PageBuilder)
    return push!(p.window.router, build(p, b))
end
function Base.push!(p::PageContext, b::Page)
    return push!(p.window.router, b)
end


function mount!(p::Page, w::Window)
    return mount!(p.component, w)
end
