abstract type AbstractPage end
abstract type AbstractPageBuilder end

struct PageContext
    app::Atak.Application
    window::AbstractWindow
    onmount::Union{Function, Nothing}
    PageContext(app::Atak.Application, win::AbstractWindow) = new(app, win, nothing)
end


struct RawPage <: AbstractPage
    builder::Function
    ctx::PageContext
    args::NamedTuple
end
isrebuildable(::RawPage) = true
render(p::RawPage) = p.builder(p.ctx, p.args)

struct RawBuilder <: AbstractPageBuilder
    fn::Function
end
build(b::RawBuilder, c::PageContext; args...) = RawPage(b.fn, c, args)


Base.@kwdef struct ViewPage <: AbstractPage
    component::AbstractComponent
    namespace::AbstractNamespace
    builder::Union{Function, Nothing}
end

function render(page::ViewPage)
    mount = Efus.mount!(page.component)
    return mount.widget
end


struct View <: AbstractPageBuilder
    init::Function
    code::Efus.ECode
    function View(init::Function, code::Union{Efus.ECode, Efus.AbstractEfusError})
        iserror(code) && (Efus.display(code); error(code))
        return new(init, code)
    end
end
function build(view::View, ctx::PageContext; args...)
    namespace = Efus.DictNamespace(ctx.app.namespace)
    view.init(namespace, ctx, args)
    evalctx = EfusEvalContext(namespace)
    component = eval!(evalctx, view.code)
    if iserror(component)
        println(Efus.format(component))
        throw(component)
    end
    if ctx.onmount isa Function
        ctx.onmount(component)
    end
    return ViewPage(;
        component,
        namespace,
        builder = (newctx) -> build(view, newctx; args...)
    )
end

const PageRoute = Function
build(f::PageRoute, c::PageContext; a...) = f(c, a)


const PageBuilder = Union{AbstractPageBuilder, PageRoute}

route(f::Function)::PageRoute = f
