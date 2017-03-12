local Menu = { }

Menu.Options = {
    height = nil,
    hidden = nil,
    wrapsAround = false,
    sizing = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.Menu"></returns>
function Menu.new(opts)
    local content = Kevlar.VerticalBranch.new(opts)
    local instance = Kevlar.ProxyNode.new(content)
    setmetatable(instance, { __index = Menu })
    setmetatable(Menu, { __index = Kevlar.ProxyNode })

    instance:ctor(content, opts)

    return instance
end

function Menu:ctor(content, opts)
    opts = self.asOptions(opts or { })

    self._items = { }
    self._vBranch = Kevlar.VerticalBranch.as(content)
    self._selectedIndex = 1
    self._wrapsAround = opts.wrapsAround or false

    self:base():onEvent(Kevlar.Event.Type.Key, function(ev)
        local key = ev:getValue()

        if (key == keys.up) then
            if (self._selectedIndex > 1 or(self._wrapsAround and self._selectedIndex == 1)) then
                self._selectedIndex = self._selectedIndex - 1

                if (self._selectedIndex < 1) then
                    self._selectedIndex = #self._items
                end

                ev:consume()
            end
        elseif (key == keys.down) then
            if (self._selectedIndex < #self._items or(self._wrapsAround and self._selectedIndex == #self._items)) then
                self._selectedIndex = self._selectedIndex + 1

                if (self._selectedIndex > #self._items) then
                    self._selectedIndex = 1
                end

                ev:consume()
            end
        elseif (key == keys.enter) then
            local item = self._items[self._selectedIndex]

            if (item and item.handler) then
                item.handler()
                ev:consume()
            end
        end

        self._vBranch:focusIndex(self._selectedIndex)
    end )

    self._vBranch:focusIndex(self._selectedIndex)
end

--- <summary></summary>
--- <returns type="Kevlar.Menu"></returns>
function Menu.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Menu.Options"></returns>
function Menu.asOptions(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function Menu:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function Menu.super() return Kevlar.ProxyNode end

function Menu:update()
    local indicator = Kevlar.Text.as(nil)

    for i, item in ipairs(self:getItems()) do
        indicator = item.node:getChildByName("indicator")

        if (i == self._selectedIndex) then
            indicator:setText("> ")
        else
            indicator:setText("  ")
        end
    end

    Menu.super().update(self)
end

function Menu:addItem(textOrNode, handler)
    handler = handler or function() end

    local node = Kevlar.Node.as(textOrNode)

    if (type(textOrNode) == "string") then
        node = Kevlar.Text.new( { text = textOrNode })
    end

    local indicator = Kevlar.Text.new( { text = "  ", align = Kevlar.TextAlign.Left, width = 2, height = 1, sizing = Kevlar.Sizing.Fixed })
    local container = Kevlar.HorizontalBranch.new( {
        children =
        {
            { name = "indicator", node = indicator },
            { name = "item", node = node }
        }
    } )

    table.insert(self._items, { node = container, handler = handler })
    self._vBranch:addChild(container)
end

function Menu:getItems()
    return self._items
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Menu = Menu