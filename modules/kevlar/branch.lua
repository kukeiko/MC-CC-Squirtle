--- Element which can contain other nodes as children.
-- @module Kevlar.Branch
local Branch = { }

Branch.Options = {
    align = nil,
    children = nil,
    height = nil,
    hidden = nil,
    sizing = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function Branch.new(opts)
    local instance = Kevlar.Node.new(opts)
    setmetatable(instance, { __index = Branch })
    setmetatable(Branch, { __index = Kevlar.Node })
    instance:ctor(opts)

    return instance
end

function Branch:ctor(opts)
    opts = self.asOptions(opts or { })

    self._nextChildId = 1
    self._children = { }
    self._childMap = { }
    self._align = opts.align or Kevlar.ContentAlign.Start

    if (type(opts.children) == "table") then
        for i, v in ipairs(opts.children) do
            if (v.node and v.name and not v.update) then
                self:addChild(v.node, v.name)
            else
                self:addChild(v)
            end
        end
    end
end

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function Branch.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Branch.Options"></returns>
function Branch.asOptions(instance)
    return instance
end

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

    local focused = self:getFocusedChild()

    if (focused) then
        focused:dispatchEvent(event)
    end

    if (not event:isConsumed()) then
        Kevlar.Node.dispatchEvent(self, event)
    end
end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Branch:getFocusedChild()
    local children = self:getVisibleChildren()

    for k, child in ipairs(children) do
        if (child:isFocused()) then
            return child
        end
    end
end

function Branch:focus()
    local focused = self:getFocusedChild()
    if (focused) then return true end

    local children = self:getVisibleChildren()

    for k, child in ipairs(children) do
        if (child:focus()) then
            return true
        end
    end

    return false
end

function Branch:focusNext(wrapAround)
    return self:focusSibling(false, wrapAround)
end

function Branch:focusPrevious(wrapAround)
    return self:focusSibling(true, wrapAround)
end

-- returns false if focused child didn't change
function Branch:focusSibling(isBack, wrapAround)
    isBack = isBack or false
    wrapAround = wrapAround or false

    local children = self:getVisibleChildren()

    if (isBack) then
        children = table.reverse(children)
    end

    local prev = Kevlar.Node.as(nil)
    local nx = Kevlar.Node.as(nil)
    local firstFocusable = Kevlar.Node.as(nil)


    for k, child in ipairs(children) do
        -- remember the first focusable in case we need to wrap around
        if (not firstFocusable and child:isFocusable()) then
            firstFocusable = child
        end

        if (prev) then
            if (child:isFocusable()) then
                nx = child
                break
            end
        elseif (child:isFocused()) then
            prev = child
        end
    end

    if (prev) then
        if (nx) then
            prev:blur()
            return nx:focus()
        elseif (wrapAround and firstFocusable ~= prev) then
            prev:blur()
            return firstFocusable:focus()
        end
    else
        return false
    end
end

function Branch:isFocused()
    return self:getFocusedChild() ~= nil
end

function Branch:isFocusable()
    local children = self:getVisibleChildren()

    for k, child in ipairs(children) do
        if (child:isFocusable()) then
            return true
        end
    end

    return false
end

function Branch:blur()
    local focused = self:getFocusedChild()

    if (focused) then
        focused:blur()
    end
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Branch = Branch