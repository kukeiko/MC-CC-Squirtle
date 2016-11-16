local CharSpace = { }

--- <summary></summary>
--- <returns type="Kevlar.CharSpace"></returns>
function CharSpace.as(instance) return instance end

--- <summary>
--- x: (int)
--- y: (int)
--- str: (string)
--- </summary>
function CharSpace:write(x, y, str) end

function CharSpace:clear() end
 
--- <returns type="number"></returns>
function CharSpace:getWidth() end

--- <returns type="number"></returns>
function CharSpace:getHeight() end

--- <returns type="number, number"></returns>
function CharSpace:getSize() end

--- <returns type="Kevlar.CharSpace"></returns>
 function CharSpace:sub(x, y, w, h)
    if (w == "*") then w = self:getWidth() -(x - 1) end
    if (h == "*") then h = self:getHeight() -(y - 1) end

    if (w < 0) then w = self:getWidth() + w -(x - 1) end
    if (h < 0) then h = self:getHeight() + h -(y - 1) end

    return Kevlar.VirtualCharSpace.new(self, x, y, w, h)
 end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.CharSpace = CharSpace