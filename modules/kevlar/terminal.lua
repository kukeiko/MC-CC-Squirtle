local Terminal = { }

--- <summary></summary>
--- <returns type="Kevlar.Terminal"></returns>
function Terminal.new(t)
    local instance = { }
    setmetatable(Terminal, { __index = Kevlar.CharSpace })
    setmetatable(instance, { __index = Terminal })

    instance:ctor(t)

    return instance
end

function Terminal:ctor(t)
    self._terminal = t or term.current()
end

--- <summary></summary>
--- <returns type="Kevlar.Terminal"></returns>
function Terminal.as(instance) return instance end

function Terminal:write(x, y, str)
    for i = 1, #str do
        self._terminal.setCursorPos(x +(i - 1), y)
        self._terminal.write(str:sub(i, i))
    end
end

function Terminal:clear()
    self._terminal.clear()
end

function Terminal:getWidth()
    local w = self._terminal.getSize()
    return w
end

function Terminal:getHeight()
    local _, h = self._terminal.getSize()
    return h
end

function Terminal:getSize()
    return self._terminal.getSize()
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Terminal = Terminal