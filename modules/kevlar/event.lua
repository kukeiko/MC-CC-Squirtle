local Event = { }

Event.Type = {
    Click = 1,
    Key = 2,
    Char = 3
}

--- <summary></summary>
--- <returns type="Kevlar.Event"></returns>
function Event.new(type, value)
    local instance = { }
    setmetatable(instance, { __index = Event })
    instance:ctor(type, value)

    return instance
end

function Event:ctor(type, value)
    self._isConsumed = false
    self._type = type
    self._value = value
end

--- <summary></summary>
--- <returns type="Kevlar.Event"></returns>
function Event.as(instance) return instance end

function Event:getType()
    return self._type
end

function Event:getValue()
    return self._value
end

function Event:consume()
    self._isConsumed = true
end

function Event:isConsumed()
    return self._isConsumed
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Event = Event