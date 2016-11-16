local VirtualCharSpace = { }

--- <summary></summary>
--- <returns type="Kevlar.VirtualCharSpace"></returns>
function VirtualCharSpace.new(parent, x, y, w, h)
    local instance = { }
    setmetatable(instance, { __index = VirtualCharSpace })

    instance:ctor(parent, x, y, w, h)

    return instance
end

function VirtualCharSpace:ctor(parent, x, y, w, h)
    self._parent = parent
    self._offsetX = x -1
    self._offsetY = y -1
    self._width = w
    self._height = h
end

--- <summary></summary>
--- <returns type="Kevlar.VirtualCharSpace"></returns>
function VirtualCharSpace.cast(instance)
    return instance
end

--- <returns type="Kevlar.ICharSpace"></returns>
function VirtualCharSpace:base()
    return self
end

function VirtualCharSpace:getWidth() return self._width end
function VirtualCharSpace:getHeight() return self._height end
function VirtualCharSpace:getSize() return self._width, self._height end

function VirtualCharSpace:write(x, y, str)
    self._parent:write(x + self._offsetX, y + self._offsetY, str)
end

function VirtualCharSpace:clear(char)
    char = char or " "
    for y = 1, self:getHeight() do
        self:write(1, y, string.rep(char, self:getWidth()))
    end
end

--- <returns type="Kevlar.ICharSpace"></returns>
function VirtualCharSpace:sub(x, y, w, h)
    return VirtualCharSpace.sub(self, x, y, w, h)
end


if (Kevlar == nil) then Kevlar = { } end
Kevlar.VirtualCharSpace = VirtualCharSpace