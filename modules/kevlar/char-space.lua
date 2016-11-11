local ICharSpace = { }

--- <summary></summary>
--- <returns type="Kevlar.ICharSpace"></returns>
function ICharSpace.as(node) return node end

--- <summary>
--- x: (int)
--- y: (int)
--- str: (string)
--- </summary>
function ICharSpace:write(x, y, str) end

function ICharSpace:clear(char) end

--- <returns type="Kevlar.ICharSpace"></returns>
function ICharSpace:sub(x, y, w, h)
    if (w == "*") then w = self:getWidth() -(x - 1) end
    if (h == "*") then h = self:getHeight() -(y - 1) end

    if (w < 0) then w = self:getWidth() + w -(x - 1) end
    if (h < 0) then h = self:getHeight() + h -(y - 1) end

    return Kevlar.VirtualCharSpace.new(self, x, y, w, h)
end

--- <returns type="number"></returns>
function ICharSpace:getWidth() end

--- <returns type="number"></returns>
function ICharSpace:getHeight() end

--- <returns type="number, number"></returns>
function ICharSpace:getSize() end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.ICharSpace = ICharSpace