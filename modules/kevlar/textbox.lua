local Textbox = { }

--- <summary></summary>
--- <returns type="Kevlar.Textbox"></returns>
function Textbox.new(text, opts)
    local instance = Kevlar.Node.new(opts)
    setmetatable(instance, { __index = Textbox })
    setmetatable(Textbox, { __index = Kevlar.Node })

    text = text or ""

    instance:ctor(text, align)

    return instance
end

function Textbox:ctor(text)
    self._text = text

    self:base():onEvent(Kevlar.Event.Type.Char, function(ev)
        self._text = self._text .. ev:getValue()
    end )

    self:base():onEvent(Kevlar.Event.Type.Key, function(ev)
        local key = ev:getValue()

        if (key == keys.backspace) then
            self._text = string.sub(self._text, 1, math.max(0, #self._text - 1))
        end
    end )
end

--- <summary></summary>
--- <returns type="Kevlar.Textbox"></returns>
function Textbox.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Textbox:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Textbox.super() return Kevlar.Node end

function Textbox:getLength()
    return string.len(self._text)
end

function Textbox:getText()
    return self._text
end

function Textbox:setText(text)
    self._text = text
end

function Textbox:update()
    local buffer = self:base():getBuffer()
    local width = buffer:getWidth()
    local offset = math.max(0, #self._text - width)
    local xMax = math.min(#self._text, width)

    buffer:clear()

    for x = 1, xMax do
        buffer:write(x, 1, self._text:sub(x + offset, x + offset))
    end
end

--- <returns type="number"></returns>
function Textbox:computeWidth(h)
    return 1
end

--- <returns type="number"></returns>
function Textbox:computeHeight(w)
    return 1
end

--- <returns type="Kevlar.Sizing"></returns>
function Textbox:getSizing()
    return self.super().getSizing(self)
end

function Textbox:setSizing(sizing)
    self.super().setSizing(self, sizing)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Textbox = Textbox