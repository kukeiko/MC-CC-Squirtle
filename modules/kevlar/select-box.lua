local SelectBox = { }

SelectBox.Options = {
    change = nil,
    height = nil,
    hidden = nil,
    items = nil,
    sizing = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.SelectBox"></returns>
function SelectBox.new(opts)
    local instance = Kevlar.ProxyNode.new(Kevlar.Text.new(opts))

    setmetatable(instance, { __index = SelectBox })
    setmetatable(SelectBox, { __index = Kevlar.ProxyNode })

    instance:ctor(opts)

    return instance
end

function SelectBox:ctor(opts)
    opts = SelectBox.asOptions(opts or { })

    self._items = { }
    self._label = Kevlar.Text.as(self:base():getProxied())
    self._selectedIndex = 1
    self._change = opts.change or function() end

    self:base():onEvent(Kevlar.Event.Type.Key, function(ev)
        local key = ev:getValue()
        local currentIndex = self._selectedIndex

        if (key == keys.left) then
            self._selectedIndex = self._selectedIndex - 1

            if (self._selectedIndex < 1) then
                self._selectedIndex = #self._items
            end
        elseif (key == keys.right) then
            self._selectedIndex = self._selectedIndex + 1

            if (self._selectedIndex > #self._items) then
                self._selectedIndex = 1
            end
        elseif (key == keys.enter) then
            local item = self._items[self._selectedIndex]

            if (item and item.handler) then
                item.handler()
            end
        end

        if (#self._items > 0) then
            self._label:setText(self._items[self._selectedIndex].text)
        end

        if (self._selectedIndex ~= currentIndex) then
            self._change(self:getValue())
        end
    end )

    if (type(opts.items) == "table") then
        for i, v in ipairs(opts.items) do
            if (type(v) == "table") then
                self:addItem(v.text, v.value, v.handler)
            else
                self:addItem(v .. "", v)
            end
        end
    end
end

--- <summary></summary>
--- <returns type="Kevlar.SelectBox"></returns>
function SelectBox.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.SelectBox.Options"></returns>
function SelectBox.asOptions(instance)
    return instance
end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function SelectBox:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function SelectBox.super() return Kevlar.ProxyNode end

function SelectBox:computeWidth(h)
    if (self:base():getSizing() == Kevlar.Sizing.Stretched) then
        local highest = 1

        for i, item in ipairs(self._items) do
            highest = math.max(highest, #item.text)
        end

        return highest
    else
        return self._proxied:computeWidth(h)
    end
end

function SelectBox:getValue()
    return(self._items[self._selectedIndex] or { }).value
end

function SelectBox:addItem(text, value, handler)
    table.insert(self._items, { text = text, value = value, handler = handler })

    if (#self._items == 1) then
        self._label:setText(text)
    end
end

function SelectBox:getItems()
    return self._items
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.SelectBox = SelectBox
