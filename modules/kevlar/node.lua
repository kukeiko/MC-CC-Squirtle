--- Base class for all elements, controls and branches.
-- @module Kevlar.Node
local Node = { }

Node.Options = {
    data = nil,
    height = nil,
    hidden = nil,
    isFocusable = nil,
    sizing = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Node.new(opts)
    local instance = { }
    setmetatable(instance, { __index = Node })
    instance:ctor(opts)

    return instance
end

function Node:ctor(opts)
    opts = self.asOptions(opts or { })

    self._buffer = Kevlar.CharBuffer.new(opts.width or 1, opts.height or 1)
    self._em = Core.EventManager.new()
    self._sizing = opts.sizing or Kevlar.Sizing.Dynamic
    self._isVisible = not opts.hidden
    self._isFocused = false
    self._isFocusable = opts.isFocusable or false
    self._data = opts.data or { }
end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Node.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node.Options"></returns>
function Node.asOptions(instance) return instance end

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

function Node:focus()
    if (not self:isFocusable()) then return false end
    self._isFocused = true

    return true
end

function Node:isFocused()
    return self._isFocused
end

function Node:isFocusable()
    return self._isFocusable
end

function Node:blur()
    self._isFocused = false
end

function Node:getEventManager()
    return self._em
end

function Node:dispatchEvent(event)
    event = Kevlar.Event.as(event)

    self._em:raise("UiEvent:" .. event:getType(), event)
end

function Node:onEvent(type, handler)
    self._em:on("UiEvent:" .. type, handler)
end

function Node:setData(name, data)
    self._data[name] = data
end

function Node:getData(name)
    return self._data[name]
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Node = Node