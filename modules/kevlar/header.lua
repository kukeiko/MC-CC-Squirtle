local Header = { }


--- <summary></summary>
--- <returns type="Kevlar.Header"></returns>
function Header.new(title, lineStr)
    local instance = { }
    setmetatable(instance, { __index = Header })

    instance:ctor(title, lineStr)

    return instance
end

function Header:ctor(title, lineStr)
    self._text = Kevlar.Text.new( { text = title, align = Kevlar.TextAlign.Center })
    self._line = Kevlar.HLine.new(lineStr)
end

--- <summary></summary>
--- <returns type="Kevlar.Header"></returns>
function Header.cast(instance) return instance end

function Header:setText(text)
    self._text:setText(text)
end

function Header:draw(charSpace)
    charSpace = Kevlar.ICharSpace.as(charSpace)
    --- , charSpace:sub(1, 2, "*", 1)
    self._text:draw(charSpace:sub(1, 1, "*", 1))
    self._line:draw(charSpace:sub(1, 2, "*", 1))
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Header = Header