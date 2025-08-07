abstract type AbstractPage end

const PageBuilder = Function

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


function Base.push!(
        ctx::PageBuildContext, builder::PageBuilder;
        args...,  # just to be explicit, builder is also a Function
    )
    page = builder(ctx)
    if isnothing(page.builder)
        page.builder = builder
        page.rebuildable = true
    end
    return if !Efus.iserror(page)
        push!(ctx.window.router, page; args...)
    else
        Efus.display(page)
        throw(page)
    end
end
Base.push!(builder::Function, ctx::PageBuildContext; args...) =
    push!(ctx, builder; args...)

function Base.push!(
        ctx::PageBuildContext, page::AbstractPage;
        args...,  # just to be explicit, builder is also a Function
    )
    return push!(ctx.window.router, page; args...)
end

function Base.pop!(ctx::PageBuildContext; args...)
    return pop!(ctx.window.router; args...)
end
