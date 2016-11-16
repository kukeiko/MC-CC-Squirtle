--- b = Kevlar.CharBuffer.new(4, 2)
--- t = Kevlar.Terminal.new()
--- todo: width / height is not really used (except by Kevlar.Node)
local CharBuffer = { }

--- <summary></summary>
--- <returns type="Kevlar.CharBuffer"></returns>
function CharBuffer.new(w, h)
    local instance = { }
    setmetatable(CharBuffer, { __index = Kevlar.CharSpace })
    setmetatable(instance, { __index = CharBuffer })

    instance:ctor(w, h)

    return instance
end

function CharBuffer:ctor(w, h)
    self._width = w
    self._height = h
    self._cache = { }
end

--- <summary></summary>
--- <returns type="Kevlar.CharBuffer"></returns>
function CharBuffer.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.CharSpace"></returns>
function CharBuffer:base() return self end

function CharBuffer:write(x, y, str)
    if (self._cache[y] == nil) then
        self._cache[y] = { }
    end

    for i = 1, #str do
        self._cache[y][x +(i - 1)] = string.sub(str, i, i)
    end
end

function CharBuffer:clear()
    self._cache = { }
end

function CharBuffer:draw(charSpace, xOffset, yOffset)
    charSpace = Kevlar.CharSpace.as(charSpace)

    xOffset =(xOffset or 0) * -1
    yOffset =(yOffset or 0) * -1

    local xMax = math.min(self:getWidth(), charSpace:getWidth())
    local yMax = math.min(self:getHeight(), charSpace:getHeight())

    for y = 1, yMax do
        for x = 1, xMax do
            local char =(self._cache[y + yOffset] or { })[x + xOffset] or " "
            charSpace:write(x, y, char)
        end
    end
end

--- <returns type="number"></returns>
function CharBuffer:getWidth()
    return self._width
end

function CharBuffer:setWidth(w)
    self._width = w
end

--- <returns type="number"></returns>
function CharBuffer:getHeight()
    return self._height
end

function CharBuffer:setHeight(h)
    self._height = h
end

--- <returns type="number, number"></returns>
function CharBuffer:getSize()
    return self._width, self._height
end

function CharBuffer:setSize(w, h)
    self:setWidth(w)
    self:setHeight(h)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.CharBuffer = CharBuffer