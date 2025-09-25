export Page, Router
export build


struct Page <: AttrapeComponent
    component::AttrapeComponent
end

function mount!(p::Page)
    return mount!(p.component, p)
end
struct Router <: AbstractRouter
    history::Vector{Page}
    current_page::Reactant{Union{Page, Nothing}}
    Router() = new([], Reactant{Union{Page, Nothing}}(nothing))
end

function Base.pop!(r::Router)
    return if length(r.history) > 0
        if isempty(r.history)
            setvalue!(r.current_page, nothing)
        else
            setvalue!(r.current_page, r.history[end])
            pop!(r.history)
        end
    end
end

function Base.push!(r::Router, p::Page; replace::Bool = false)
    if !isnothing(getvalue(r.current_page)) && !replace
        push!(r.history, getvalue(r.current_page))
    end
    return setvalue!(r.current_page, p)
end
