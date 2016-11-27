local Window = { }

--- <summary></summary>
--- <returns type="Kevlar.Window"></returns>
function Window.new(content, w, h)
    local instance = Kevlar.Node.new(w, h)
    setmetatable(instance, { __index = Window })
    setmetatable(Window, { __index = Kevlar.Node })

    instance:ctor(content)

    return instance
end

function Window:ctor(content)
    self._content = Kevlar.Node.as(content)
end

--- <summary></summary>
--- <returns type="Kevlar.Window"></returns>
function Window.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Window:base() return self end

function Window:update()
    local buffer = self:base():getBuffer()

    if (self._content == nil) then
        buffer:clear()
        return
    end

    self._content:setSize(buffer:getSize())
    self._content:update()
    self._content:draw(buffer)
end

function Window:getContent()
    return self._content
end

function Window:setContent(content)
    self._content = content
end

function Window:dispatchEvent(event)
    if (self._content == nil) then return end

    self._content:dispatchEvent(event)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Window = Window