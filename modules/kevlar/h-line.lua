local HLine = { }


--- <summary>
--- A line drawn horicontally, repeating the given string
--- </summary>
--- <returns type="Kevlar.HLine"></returns>
function HLine.new(str)
    local instance = { }
    setmetatable(instance, { __index = HLine })

    str = str or "-"
    instance:ctor(str)

    return instance
end

function HLine:ctor(str)
    self._str = str
end

--- <summary></summary>
--- <returns type="Kevlar.HLine"></returns>
function HLine.cast(instance) return instance end

function HLine:draw(charSpace)
    charSpace = Kevlar.ICharSpace.as(charSpace)

    local i = 1

    for x = 1, charSpace:getWidth() do
        charSpace:write(x, 1, self._str:sub(i, i))
        i =(i % #self._str) + 1
    end
end

function HLine:getString()
    return self._str
end

function HLine:setString(str)
    self._str = str
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.HLine = HLine