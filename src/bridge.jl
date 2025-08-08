Base.convert(::Type{Mousetrap.detail._Orientation}, v::Efus.ESymbol) = (
    if v.value ∈ [:v, :vertical]
        Mousetrap.ORIENTATION_VERTICAL
    elseif v.value ∈ [:h, :horizontal]
        Mousetrap.ORIENTATION_HORIZONTAL
    else
        throw("$v is not a valid mousetrap orientation.")
    end
)

Base.convert(::Type{Mousetrap.JustifyMode}, sym::Efus.ESymbol) = (
    if sym.value ∈ [:l, :left]
        Mousetrap.JUSTIFY_MODE_LEFT
    elseif sym.value ∈ [:r, :right]
        Mousetrap.JUSTIFY_MODE_RIGHT
    elseif sym.value ∈ [:f, :fill]
        Mousetrap.JUSTIFY_MODE_FILL
    elseif sym.value ∈ [:c, :center]
        Mousetrap.JUSTIFY_MODE_CENTER
    else
        throw("$sym is not a valid side")
    end
)

Base.convert(::Type{Mousetrap.LabelWrapMode}, sym::Efus.ESymbol) = (
    if sym.value === :none
        Mousetrap.LABEL_WRAP_MODE_NONE
    elseif sym.value === :word
        Mousetrap.LABEL_WRAP_MODE_ONLY_ON_WORD
    elseif sym.value === :char
        Mousetrap.LABEL_WRAP_MODE_ONLY_ON_CHAR
    elseif sym.value === :both
        Mousetrap.LABEL_WRAP_MODE_WORD_OR_CHAR
    else
        error("$(sym.value) is not a valid wrap mode, accepted: none, word, char, both")
    end
)
Base.convert(::Type{Mousetrap.EllipsizeMode}, sym::Efus.ESymbol) = (
    if sym.value === :none
        Mousetrap.ELLIPSIZE_MODE_NONE
    elseif sym.value === :start
        Mousetrap.ELLIPSIZE_MODE_START
    elseif sym.value === :end
        Mousetrap.ELLIPSIZE_MODE_END
    elseif sym.value === :middle
        Mousetrap.ELLIPSIZE_MODE_MIDDLE
    else
        error("$(sym.value) is not a valid ellipsze mode, acepted: none, start, end, middle")
    end
)
