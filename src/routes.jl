struct Router
    stack::Vector{AbstractPage}
    observable::Efus.EObservable
end
router() = Router(AbstractPage[], Efus.EObservable())
router(home::AbstractPage) = Router(AbstractPage[home], Efus.EObservable())


function Base.push!(
        r::Router, page::AbstractPage;
        replace::Bool = false, clear::Bool = false,
        notify::Bool = true
    )::AbstractPage
    clear && empty!(r)
    replace && length(r.stack) > 0 && pop!(r)
    push!(r.stack, page)
    notify && Efus.notify(r)
    return page
end

function Base.push!(
        ctx::PageContext, builder_or_page::Union{AbstractPage, PageBuilder};
        replace::Bool = false, clear::Bool = false, notify::Bool = true
    )::AbstractPage
    page::AbstractPage = if builder_or_page isa PageBuilder
        build(builder_or_page, ctx)
    else
        builder_or_page
    end
    return push!(ctx.window.router, page; replace, clear, notify)
end

function Base.pop!(r::Router; notify::Bool = true)::Union{AbstractPage, Nothing}
    length(r.stack) == 0 && return nothing
    poped = pop!(r.stack)
    notify && Efus.notify(r)
    return poped
end
Base.empty!(r::Router) = empty!(r.stack)

function getcurrentpage(r::Router)
    current = if isempty(r.stack)
        nothing
    else
        last(r.stack)
    end
    return current
end


# @ignore
@redirectobservablemethods r::Router r.observable
