local Header = { }


--- <summary></summary>
--- <returns type="Kevlar.Header"></returns>
function Header.new(title, lineChar, buffer)
    local instance = { }
    setmetatable(instance, { __index = Header })

    instance:ctor(title, lineChar, buffer)

    return instance
end

function Header:ctor(title, lineChar, buffer)
    self._buffer = Kevlar.IBuffer.as(buffer)
    self._text = Kevlar.Text.new(title, Kevlar.Text.Align.Center, buffer:sub(1, 1, "*", 1))
    self._line = Kevlar.HLine.new(lineChar, buffer:sub(1, 2, "*", 1))
end

--- <summary></summary>
--- <returns type="Kevlar.Header"></returns>
function Header.cast(instance) return instance end

function Header:setText(text)
    self._text:setText(text)
end

function Header:draw()
    self._text:draw()
    self._line:draw()
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Header = Header