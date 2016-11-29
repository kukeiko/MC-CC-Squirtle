local NumberBox = { }

NumberBox.Options = {
    height = nil,
    hidden = nil,
    max = nil,
    min = nil,
    sizing = nil,
    step = nil,
    value = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.NumberBox"></returns>
function NumberBox.new(opts)
    local instance = Kevlar.ProxyNode.new(Kevlar.Text.new(opts))

    setmetatable(instance, { __index = NumberBox })
    setmetatable(NumberBox, { __index = Kevlar.ProxyNode })

    instance:ctor(opts)

    return instance
end

function NumberBox:ctor(opts)
    opts = self.asOptions(opts or { })

    self._label = Kevlar.Text.as(self:base():getProxied())
    self._min = opts.min
    self._max = opts.max
    self._step = opts.step
    self._value = opts.value
    self._prefix = " "

    local updateValue = function()
        if (self._value == nil) then
            self._label:setText(self._prefix)
            return
        end

        if (self._prefix == "-" and self._value > 0) then
            self._value = self._value * -1
        elseif (self._prefix == " " and self._value < 0) then
            self._value = self._value * -1
        end

        self._value = math.min(self._value, self._max or self._value)
        self._value = math.max(self._value, self._min or self._value)

        self._label:setText(self._prefix .. math.abs(self._value))
    end

    self:base():onEvent(Kevlar.Event.Type.Key, function(ev)
        local key = ev:getValue()

        if (key == keys.left) then
            if (self._value ~= nil) then
                self._value = self._value -(math.max(1, self._step or 1))
            end
        elseif (key == keys.right) then
            if (self._value ~= nil) then
                self._value = self._value +(math.max(1, self._step or 1))
            end
        elseif (key == keys.backspace) then
            if (self._value) then
                local str = tostring(self._value)

                if ((#str == 1 and self._value >= 0) or(#str == 2 and self._value < 0)) then
                    self._value = nil
                else
                    self._value = tonumber(string.sub(str, 1, #str - 1))
                end
            end
        end

        updateValue()
    end )

    self:base():onEvent(Kevlar.Event.Type.Char, function(ev)
        local char = ev:getValue()
        local number = tonumber(char)

        if (char == "-") then
            if ((self._min or -1) < 0) then
                self._prefix = "-"
            end
        elseif (char == "+") then
            self._prefix = " "
        elseif (number) then
            self._value = tonumber((self._value or "") .. "" .. number)
        end

        updateValue()
    end )
end

--- <summary></summary>
--- <returns type="Kevlar.NumberBox"></returns>
function NumberBox.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.NumberBox.Options"></returns>
function NumberBox.asOptions(instance)
    return instance
end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function NumberBox:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function NumberBox.super() return Kevlar.ProxyNode end

function NumberBox:computeWidth(h)
    if (self:base():getSizing() == Kevlar.Sizing.Stretched) then
        local max = self._max or 1
        local highest = #(max .. "")

        if (self._min and math.abs(self._min) > max) then
            highest = #(self._min .. "")
        end

        return highest
    else
        return self._proxied:computeWidth(h)
    end
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.NumberBox = NumberBox
