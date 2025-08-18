struct GridViewBackend <: AttrapeBackend end

const GridView = Efus.Component{GridViewBackend}

function Efus.mount!(c::GridView)::AttrapeMount
    frame = Mousetrap.GridView(c[:orient]::Mousetrap.detail._Orientation)
    c.mount = SimpleMount(frame, outlet)
    c[:min] && set_min_n_columns!(frame, c[:min]::Integer)
    c[:max] && set_max_n_columns!(frame, c[:max]::Integer)
    processcommonargs!(c, frame)
    isnothing(c.parent) || childgeometry!(c.parent, c)
    mount!.(c.children)
    return c.mount
end


function Efus.update!(c::Button)
    return updateutil!(c) do name, value
        if name === :min
            set_min_n_columns!(frame, value::Integer)
        elseif name == :max
            set_max_n_columns!(frame, value::Integer)
        else
            missing
        end
    end
end

const gridView = Efus.EfusTemplate(
    :GridView,
    GridViewBackend,
    Efus.TemplateParameter[
        :orient => Mousetrap.detail._Orientation => ORIENTATION_VERTICAL,
        :min => Integer,
        :max => Integer,
        COMMON_ARGS...,
    ]
)
