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

Base.@kwdef struct ComponentPage <: AbstractPage
    component::AbstractComponent
    namespage::AbstractNamespace
    builder::Union{Function, Nothing}
end


struct PageBuilder
    init::Function
    code::Efus.ECode
end
function build(builder::PageBuilder, ctx::PageBuildContext; args...)
    namespace = Efus.DictNamespace(ctx.app.namespace)
    builder.init(namespace, ctx, args)
    evalctx = EfusEvalContext(namespace)
    component = eval!(evalctx, builder.code)
    if iserror(component)
        println(Efus.format(component))
        throw(component)
    end
    if ctx.onmount isa Function
        ctx.onmount(component)
    end
    return ComponentPage(;
        component,
        namespace,
        builder = (newctx) -> build(builder, newctx; args...)
    )
end


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
