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

function Branch:getChildByName(name)
    return self._childMap[name]
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Branch = Branch