local Menu = { }

--- <summary></summary>
--- <returns type="Kevlar.Sync.Menu"></returns>
function Menu.new(charSpace)
    local instance = { }
    setmetatable(instance, { __index = Menu })
    instance:ctor(charSpace)

    return instance
end

function Menu:ctor(charSpace)
    self._items = { }
    self._selectedIndex = 1
    self._doQuit = false
    self._charSpace = charSpace
end

--- <summary></summary>
--- <returns type="Kevlar.Sync.Menu"></returns>
function Menu.cast(instance) return instance end

function Menu:quit()
    self._doQuit = true
end

function Menu:run()
    self:draw()

    while (not self._doQuit) do
        local key = Core.MessagePump.pull("key")
        local selectedIndex = self._selectedIndex or 1
        local newIndex = selectedIndex

        if (key == keys.up) then
            newIndex = newIndex - 1
            if (newIndex <= 0) then newIndex = #self._items end
        elseif (key == keys.down) then
            newIndex = newIndex + 1
            if (newIndex > #self._items) then newIndex = 1 end
        elseif (key == keys.enter) then
            self._items[selectedIndex].handler(self._items[selectedIndex].data)
        elseif (key == keys.f4) then
            self:quit()
        end

        self._selectedIndex = newIndex

        self:draw()
    end
end

function Menu:draw()
    local charSpace = Kevlar.ICharSpace.as(self._charSpace)
    charSpace:clear()

    for i = 1, charSpace:getHeight() do
        local item = self._items[i]
        if (item == nil) then break end

        if (i == self._selectedIndex) then
            charSpace:write(1, i, ">")
        else
            charSpace:write(1, i, " ")
        end

        charSpace:write(2, i, item.text)
    end
end

function Menu:addItem(text, handler, data)
    table.insert(self._items, {
        text = text,
        handler = handler,
        data = data
    } )
end

if (Kevlar == nil) then Kevlar = { } end
if (Kevlar.Sync == nil) then Kevlar.Sync = { } end
Kevlar.Sync.Menu = Menu