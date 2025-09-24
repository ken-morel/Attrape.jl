# export Picture
# mutable struct Picture <: AttrapeComponent
#     const source::MayBeReactive{Any}
#     const size::Union{Efus.Size, Nothing}
#     const margin::Union{Efus.Size, Nothing}
#     const expand::Union{Bool, Nothing}
#     const halign::Union{Mousetrap.Alignment, Nothing}
#     const valign::Union{Mousetrap.Alignment, Nothing}
#     widget::Union{Mousetrap.Picture, Nothing}
#     const catalyst::Catalyst
#     const dirty::Dict{Symbol, Any}
#     function Picture(;
#             source::MayBeReactive{Any},
#             size::Union{Efus.Size, Nothing} = nothing,
#             margin::Union{Efus.Size, Nothing} = nothing,
#             expand::Union{Bool, Nothing} = nothing,
#             halign::Union{Mousetrap.Alignment, Nothing} = nothing,
#             valign::Union{Mousetrap.Alignment, Nothing} = nothing
#         )
#         return new(source, size, margin, expand, halign, valign, nothing, Catalyst(), Dict())
#     end
# end
#
# function mount!(p::Picture, ::AttrapeComponent)
#     p.widget = Mousetrap.Picture()
#     Mousetrap.set_filename!(p.widget, resolve(p.source)::String)
#
#     p.source isa AbstractReactive && catalyze!(p.catalyst, p.source) do value
#         p.dirty[:source] = value
#         update!(p)
#     end
#
#     apply_layout!(p, p.widget)
#
#     return p.widget
# end
#
# function unmount!(p::Picture)
#     inhibit!(p.catalyst)
#     return p.widget = nothing
# end
#
# function update!(p::Picture)
#     isnothing(p.widget) && return
#     for (dirt, val) in p.dirty
#         if dirt == :source
#             Mousetrap.set_filename!(p.widget, val::String)
#         end
#     end
#     return
# end
