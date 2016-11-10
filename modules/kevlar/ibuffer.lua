local IBuffer = { }

--- <summary></summary>
--- <returns type="Kevlar.IBuffer"></returns>
function IBuffer.as(node) return node end

--- <summary>
--- x: (int)
--- y: (int)
--- str: (string)
--- </summary>
function IBuffer:write(x, y, str) end

function IBuffer:clear(char) end

--- <returns type="Kevlar.IBuffer"></returns>
function IBuffer:sub(x, y, w, h)
    if (w == "*") then w = self:getWidth() -(x - 1) end
    if (h == "*") then h = self:getHeight() -(y - 1) end

    if (w < 0) then w = self:getWidth() + w -(x - 1) end
    if (h < 0) then h = self:getHeight() + h -(y - 1) end

    return Kevlar.VirtualBuffer.new(self, x, y, w, h)
end

--- <returns type="number"></returns>
function IBuffer:getWidth() end

--- <returns type="number"></returns>
function IBuffer:getHeight() end

--- <returns type="number, number"></returns>
function IBuffer:getSize() end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.IBuffer = IBuffer