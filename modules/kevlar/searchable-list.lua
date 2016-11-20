local SearchableList = { }

--- <summary></summary>
--- <returns type="Kevlar.SearchableList"></returns>
function SearchableList.new()
    local content = Kevlar.VerticalBranch.new()
    local instance = Kevlar.ProxyNode.new(content)
    setmetatable(instance, { __index = SearchableList })
    setmetatable(SearchableList, { __index = Kevlar.ProxyNode })

    instance:ctor(content)

    return instance
end

function SearchableList:ctor(content)
    self._items = { }
    self._vBranch = Kevlar.VerticalBranch.as(content)
    self._searchBox = Kevlar.Textbox.new()
    self._hLine = Kevlar.HLine.new()
    self._pagedList = Kevlar.PagedList.new()

    self._pagedList:setSizing(Kevlar.Sizing.Stretched)

    self._vBranch:addChild(self._searchBox, "search-box")
    self._vBranch:addChild(self._hLine, "header-line")
    self._vBranch:addChild(self._pagedList, "paged-list")
end

--- <summary></summary>
--- <returns type="Kevlar.SearchableList"></returns>
function SearchableList.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function SearchableList:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function SearchableList.super() return Kevlar.ProxyNode end

function SearchableList:update()
    local items = self:getFilteredItems()
    self._pagedList:clearItems()

    for i = 1, #items do
        self._pagedList:addItem(items[i].name, items[i].handler)
    end

    SearchableList.super().update(self)
end

function SearchableList:addItem(name, handler)
    table.insert(self._items, { name = name, handler = handler })
end

function SearchableList:getFilteredItems()
    local search = self._searchBox:getText()
    if (#search == 0) then return self._items end

    local keywords = string.split(search, " ")

    for i = 1, #keywords do
        keywords[i] = string.lower(keywords[i])
    end

    local filtered = { }
    for i = 1, #self._items do
        local name = string.lower(self._items[i].name)
        local matches = true

        for e = 1, #keywords do
            if (not string.find(name, keywords[e])) then
                matches = false
                break
            end
        end

        if (matches) then
            table.insert(filtered, self._items[i])
        end
    end

    return filtered
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.SearchableList = SearchableList