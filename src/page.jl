abstract type AbstractPage end

struct PageBuildContext
    app::AbstractApplication
    window::AbstractWindow
    onmount::Union{Function, Nothing}
    PageBuildContext(app::AbstractApplication, win::AbstractWindow) = new(app, win, nothing)
end


struct BuilderPage <: AbstractPage
    builder::Function
end
isrebuildable(::BuilderPage) = false

render(b::BuilderPage, ctx::PageBuildContext) = b.builder(ctx)
