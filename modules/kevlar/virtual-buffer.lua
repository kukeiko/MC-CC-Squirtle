local VirtualBuffer = { }

--- <summary></summary>
--- <returns type="Kevlar.VirtualBuffer"></returns>
function VirtualBuffer.new(parent, x, y, w, h)
    local instance = { }
    setmetatable(instance, { __index = VirtualBuffer })

    instance:ctor(parent, x, y, w, h)

    return instance
end

function VirtualBuffer:ctor(parent, x, y, w, h)
    self._parent = parent
    self._offsetX = x -1
    self._offsetY = y -1
    self._width = w
    self._height = h
end

--- <summary></summary>
--- <returns type="Kevlar.VirtualBuffer"></returns>
function VirtualBuffer.cast(instance)
    return instance
end

--- <returns type="Kevlar.IBuffer"></returns>
function VirtualBuffer:base()
    return self
end

function VirtualBuffer:getWidth() return self._width end
function VirtualBuffer:getHeight() return self._height end
function VirtualBuffer:getSize() return self._width, self._height end

function VirtualBuffer:write(x, y, str)
    self._parent:write(x + self._offsetX, y + self._offsetY, str)
end

function VirtualBuffer:clear(char)
    char = char or " "
    for y = 1, self:getHeight() do
        self:write(1, y, string.rep(char, self:getWidth()))
    end
end

--- <returns type="Kevlar.IBuffer"></returns>
function VirtualBuffer:sub(x, y, w, h)
    return Kevlar.IBuffer.sub(self, x, y, w, h)
end


if (Kevlar == nil) then Kevlar = { } end
Kevlar.VirtualBuffer = VirtualBuffer