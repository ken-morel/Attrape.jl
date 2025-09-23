export @page_str, @pagebuilder_str

macro page_str(txt::String)
    file = "<attrape page at $(__source__.file):$(__source__.line)>"
    code = Efus.parseandgenerate(txt; file)
    return quote
        $Page($(esc(code)))
    end
end

macro pagebuilder_str(txt::String)
    file = "<attrape pagebuilder at $(__source__.file):$(__source__.line)>"
    code = Efus.parseandgenerate(txt; file)
    return quote
        $PageBuilder() do ctx
            $Page($(esc(code)))
        end
    end
end
