local Terminal = { }

--- <summary></summary>
--- <returns type="Kevlar.Terminal"></returns>
function Terminal.new()
    local instance = { }
    setmetatable(Terminal, { __index = Kevlar.IBuffer })
    setmetatable(instance, { __index = Terminal })

    instance:ctor(terminal)

    return instance
end

function Terminal:ctor()
    self._terminal = term.current()
    self._offsetX = 0
    self._offsetY = 0
end

--- <summary></summary>
--- <returns type="Kevlar.Terminal"></returns>
function Terminal.cast(instance)
    return instance
end

--- <returns type="Kevlar.IBuffer"></returns>
function Terminal:base()
    return self
end

function Terminal:clear(char)
    -- todo: implement with char
    self._terminal.clear()
end

--- <returns type="Kevlar.IBuffer"></returns>
function Terminal:sub(x, y, w, h)
    return Kevlar.IBuffer.sub(self, x, y, w, h)
end

function Terminal:getWidth()
    local w = self._terminal.getSize()
    return w
end

function Terminal:getHeight()
    local _, h = self._terminal.getSize()
    return h
end

function Terminal:getSize() return self._terminal.getSize() end

function Terminal:write(x, y, str)
    for i = 1, #str do
        self._terminal.setCursorPos(x + self._offsetX +(i - 1), y + self._offsetY)
        self._terminal.write(str:sub(i, i))
    end
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Terminal = Terminal