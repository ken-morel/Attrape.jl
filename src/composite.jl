export Composite


struct Composite <: AttrapeComponent
    build::Function
end

function (c::Composite)(args...)
    return c.build(args...)
end
