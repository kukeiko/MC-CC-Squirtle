local Branch = { }

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function Branch.new(w, h)
    local instance = Kevlar.Node.new(w, h)
    setmetatable(instance, { __index = Branch })
    setmetatable(Branch, { __index = Kevlar.Node })
    instance:ctor()

    return instance
end

function Branch:ctor()
    self._nextChildId = 1
    self._children = { }
    self._childMap = { }
    self._align = Kevlar.ContentAlign.Start
    self._focusIndex = nil
end

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function Branch.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Branch:base() return self end

function Branch:addChild(node, name)
    local id = self._nextChildId
    name = name or "child:" .. id
    self._nextChildId = self._nextChildId + 1

    table.insert(self._children, node)
    self._childMap[name] = node
end

function Branch:getChildren()
    return self._children
end

function Branch:getVisibleChildren()
    local visible = { }
    local child = Kevlar.Node.as(nil)

    for i, child in ipairs(self._children) do
        if (child:isVisible()) then
            table.insert(visible, child)
        end
    end

    return visible
end

function Branch:getChildByName(name)
    return self._childMap[name]
end

function Branch:removeChildByName(name)
    local child = self._childMap[name]
    if (child == nil) then return end

    local index = nil

    for i, v in ipairs(self._children) do
        if (v == child) then
            index = i
            break
        end
    end

    if (index) then
        table.remove(self._children, index)
        self._childMap[name] = nil
    end
end

function Branch:removeChildren()
    self._children = { }
    self._childMap = { }
end

function Branch:setAlign(align)
    self._align = align
end

function Branch:getAlign()
    return self._align
end

function Branch:dispatchEvent(event)
    child = Kevlar.Node.as(nil)
    event = Kevlar.Event.as(event)

    local children = self:getVisibleChildren()

    if (self._focusIndex and self._focusIndex > 0 and self._focusIndex <= #children) then
        self._children[self._focusIndex]:dispatchEvent(event)
    else
        for k, child in ipairs(children) do
            child:dispatchEvent(event)

            if (event:isConsumed()) then
                break
            end
        end
    end

    if (not event:isConsumed()) then
        Kevlar.Node.dispatchEvent(self, event)
    end
end

function Branch:focusIndex(index)
    self._focusIndex = index
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Branch = Branch