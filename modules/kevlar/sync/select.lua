local Select = { }

--- <summary></summary>
--- <returns type="Kevlar.Sync.Select"></returns>
function Select.new(charSpace)
    local instance = { }
    setmetatable(instance, { __index = Select })
    instance:ctor(charSpace)

    return instance
end

function Select:ctor(charSpace)
    self._options = { }
    self._selectedIndex = 1
    self._doQuit = false
    self._charSpace = charSpace
end

--- <summary></summary>
--- <returns type="Kevlar.Sync.Select"></returns>
function Select.cast(instance) return instance end

function Select:run()
    if (#self._options == 0) then return nil end

    self:draw()

    while (not self._doQuit) do
        local key = Core.MessagePump.pull("key")
        local selectedIndex = self._selectedIndex or 1
        local newIndex = selectedIndex

        if (key == keys.up) then
            newIndex = newIndex - 1
            if (newIndex <= 0) then newIndex = #self._options end
        elseif (key == keys.down) then
            newIndex = newIndex + 1
            if (newIndex > #self._options) then newIndex = 1 end
        elseif (key == keys.enter) then
            return self._options[selectedIndex].data
        elseif (key == Kevlar.escape) then
            return nil
        end

        self._selectedIndex = newIndex
        self:draw()
    end
end

function Select:draw()
    local charSpace = Kevlar.ICharSpace.as(self._charSpace)
    charSpace:clear()

    for i = 1, charSpace:getHeight() do
        local item = self._options[i]
        if (item == nil) then break end

        if (i == self._selectedIndex) then
            charSpace:write(1, i, ">")
        else
            charSpace:write(1, i, " ")
        end

        charSpace:write(2, i, item.text)
    end
end

function Select:clear()
    self._options = { }
end

function Select:addOption(text, data)
    if (data == nil) then error("data for an select option can't be nil") end

    table.insert(self._options, {
        text = text,
        data = data
    } )
end

if (Kevlar == nil) then Kevlar = { } end
if (Kevlar.Sync == nil) then Kevlar.Sync = { } end
Kevlar.Sync.Select = Select