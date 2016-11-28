local PagedList = { }

--- <summary></summary>
--- <returns type="Kevlar.PagedList"></returns>
function PagedList.new(opts)
    local instance = Kevlar.Node.new(opts)
    setmetatable(instance, { __index = PagedList })
    setmetatable(PagedList, { __index = Kevlar.Node })
    instance:ctor()

    return instance
end

function PagedList:ctor()
    self._items = { }
    self._selectionIndex = 1
    self._pageIndex = 1

    self:base():onEvent(Kevlar.Event.Type.Key, function(ev)
        local key = ev:getValue()

        if (key == keys.up) then
            self._selectionIndex = self._selectionIndex - 1
        elseif (key == keys.down) then
            self._selectionIndex = self._selectionIndex + 1
        elseif (key == keys.left) then
            self._pageIndex = self._pageIndex - 1
        elseif (key == keys.right) then
            self._pageIndex = self._pageIndex + 1
        elseif (key == keys.enter) then
            local item = self._items[self._selectionIndex]
            if (item and item.handler) then
                item.handler()
            end
        end
    end )
end

--- <summary></summary>
--- <returns type="Kevlar.PagedList"></returns>
function PagedList.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function PagedList:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function PagedList.super() return Kevlar.Node end

function PagedList:update()
    local buffer = self:base():getBuffer()
    buffer:clear()

    local numItemsDrawable = math.min(buffer:getHeight() -1, #self._items)
    if (numItemsDrawable == 0) then return end

    local numPages = math.ceil(#self._items / numItemsDrawable)

    if (self._pageIndex <= 0) then
        self._pageIndex = numPages
    elseif (self._pageIndex > numPages) then
        self._pageIndex = 1
    end

    local itemOffset = numItemsDrawable *(self._pageIndex - 1)
    local numItems = math.min(numItemsDrawable, #self._items - itemOffset)

    if (self._selectionIndex <= 0) then
        self._selectionIndex = numItems
    elseif (self._selectionIndex > numItems) then
        self._selectionIndex = 1
    end

    for y = 1, numItems do
        local item = self._items[y + itemOffset]

        if (y == self._selectionIndex) then
            buffer:write(1, y, ">" .. item.name)
        else
            buffer:write(1, y, " " .. item.name)
        end
    end

    buffer:write(1, buffer:getHeight(), self._pageIndex .. "/" .. numPages)
end

function PagedList:addItem(name, handler)
    table.insert(self._items, { name = name, handler = handler })
end

function PagedList:clearItems()
    self._items = { }
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.PagedList = PagedList