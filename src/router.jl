export Page, Router
export back!, build


struct Page
    component::AttrapeComponent
end
struct Router <: AbstractRouter
    history::Vector{Page}
    current_page::Reactant{Union{Page, Nothing}}
    Router() = new([], Reactant{Union{Page, Nothing}}(nothing))
end

function back!(r::Router)
    return if length(r.history) > 0
        pop!(r.history)
        setvalue!(r.current_page, length(r.history) > 0 ? r.history[end] : nothing)
    end
end

function Base.push!(r::Router, p::Page)
    push!(r.history, p)
    return setvalue!(r.current_page, p)
end
