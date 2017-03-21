local ProxyNode = { }

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function ProxyNode.new(proxied)
    local instance = { }
    setmetatable(instance, { __index = ProxyNode })
    instance:ctor(proxied)

    return instance
end

function ProxyNode:ctor(proxied)
    self._proxied = Kevlar.Node.as(proxied)
end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function ProxyNode.as(instance) return instance end

function ProxyNode:getProxied()
    return self._proxied
end

function ProxyNode:update()
    self._proxied:update()
end

function ProxyNode:draw(charSpace, xOffset, yOffset)
    self._proxied:draw(charSpace, xOffset, yOffset)
end

--- <returns type="Kevlar.CharSpace"></returns>
function ProxyNode:getBuffer()
    return self._proxied:getBuffer()
end

--- <returns type="number"></returns>
function ProxyNode:getWidth()
    return self._proxied:getWidth()
end

function ProxyNode:setWidth(w)
    self._proxied:setWidth(w)
end

--- <returns type="number"></returns>
function ProxyNode:getHeight()
    return self._proxied:getHeight()
end

function ProxyNode:setHeight(h)
    self._proxied:setHeight(h)
end

--- <returns type="number, number"></returns>
function ProxyNode:getSize()
    return self._proxied:getSize()
end

function ProxyNode:setSize(w, h)
    self._proxied:setSize(w, h)
end

--- <returns type="number"></returns>
function ProxyNode:computeWidth(h)
    return self._proxied:computeWidth(h)
end

--- <returns type="number"></returns>
function ProxyNode:computeHeight(w)
    return self._proxied:computeHeight(w)
end

--- <returns type="Kevlar.Sizing"></returns>
function ProxyNode:getSizing()
    return self._proxied:getSizing()
end

function ProxyNode:setSizing(sizing)
    self._proxied:setSizing(sizing)
end

function ProxyNode:show()
    self._proxied:show()
end

function ProxyNode:hide()
    self._proxied:hide()
end

function ProxyNode:isVisible()
    return self._proxied:isVisible()
end

function ProxyNode:focus()
    return self._proxied:focus()
end

function ProxyNode:isFocused()
    return self._proxied:isFocused()
end

function ProxyNode:isFocusable()
    return self._proxied:isFocusable()
end

function ProxyNode:blur()
    self._proxied:blur()
end

function ProxyNode:dispatchEvent(event)
    self._proxied:dispatchEvent(event)
end

function ProxyNode:onEvent(type, handler)
    self._proxied:onEvent(type, handler)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.ProxyNode = ProxyNode