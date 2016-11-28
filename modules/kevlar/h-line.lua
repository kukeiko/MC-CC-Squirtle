local HLine = { }

--- <summary>
--- A line drawn horicontally, repeating the given string
--- </summary>
--- <returns type="Kevlar.HLine"></returns>
function HLine.new(str, opts)
    local instance = Kevlar.Node.new(opts)
    setmetatable(instance, { __index = HLine })
    setmetatable(HLine, { __index = Kevlar.Node })

    str = str or "-"
    instance:ctor(str)

    return instance
end

function HLine:ctor(str)
    self._str = str
end

--- <summary></summary>
--- <returns type="Kevlar.HLine"></returns>
function HLine.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function HLine:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function HLine.super() return Kevlar.Node end

function HLine:update()
    local buffer = self:base():getBuffer()
    local i = 1

    for x = 1, buffer:getWidth() do
        buffer:write(x, 1, self._str:sub(i, i))
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