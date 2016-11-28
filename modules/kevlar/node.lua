local Node = { }

Node.Options = {
    height = nil,
    hidden = nil,
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
end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Node.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node.Options"></returns>
function Node.asOptions(instance)
    return instance
end

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