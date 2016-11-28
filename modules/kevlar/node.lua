local Node = { }

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Node.new(w, h)
    local instance = { }
    setmetatable(instance, { __index = Node })
    instance:ctor(w, h)

    return instance
end

function Node:ctor(w, h)
    self._buffer = Kevlar.CharBuffer.new(w or 1, h or 1)
    self._em = Core.EventManager.new()
    self._sizing = Kevlar.Sizing.Dynamic
    self._isVisible = true
end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Node.as(instance) return instance end

function Node:update() end

function Node:draw(charSpace, xOffset, yOffset)
    self._buffer:draw(charSpace, xOffset, yOffset)
end

--- <returns type="Kevlar.CharSpace"></returns>
function Node:getBuffer()
    return self._buffer
end

--- <returns type="number"></returns>
function Node:getWidth()
    return self._buffer:getWidth()
end

function Node:setWidth(w)
    self._buffer:setWidth(w)
end

--- <returns type="number"></returns>
function Node:getHeight()
    return self._buffer:getHeight()
end

function Node:setHeight(h)
    self._buffer:setHeight(h)
end

--- <returns type="number, number"></returns>
function Node:getSize()
    return self._buffer:getSize()
end

function Node:setSize(w, h)
    self._buffer:setSize(w, h)
end

--- <returns type="number"></returns>
function Node:computeWidth(h)
    return 1
end

--- <returns type="number"></returns>
function Node:computeHeight(w)
    return 1
end

--- <returns type="Kevlar.Sizing"></returns>
function Node:getSizing()
    return self._sizing
end

function Node:setSizing(sizing)
    self._sizing = sizing
end

function Node:show()
    self._isVisible = true
end

function Node:hide()
    self._isVisible = false
end

function Node:isVisible()
    return self._isVisible
end

function Node:dispatchEvent(event)
    event = Kevlar.Event.as(event)

    self._em:raise("UiEvent:" .. event:getType(), event)
end

function Node:onEvent(type, handler)
    self._em:on("UiEvent:" .. type, handler)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Node = Node