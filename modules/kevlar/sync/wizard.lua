local Wizard = { }

--- <summary>
--- </summary>
--- <returns type="Kevlar.Sync.Wizard"></returns>
function Wizard.new(charSpace)
    local instance = { }
    setmetatable(instance, { __index = Wizard })
    instance:ctor(charSpace)

    return instance
end

function Wizard:ctor(charSpace)
    self._numEntered = 0
    self._charSpace = Kevlar.ICharSpace.as(charSpace)
    self._charSpace:clear()
end

function Wizard:printDashLine()
    local w = self._charSpace:getWidth()

    self._charSpace:write(1, 1, string.rep("-", w))
end

function Wizard:getInt(message, min, max)
    if (min ~= nil and max ~= nil) then
        message = message .. " (" .. min .. " - " .. max .. ")"
    elseif (min ~= nil) then
        message = message .. " (min. " .. min .. ")"
    elseif (max ~= nil) then
        message = message .. " (max. " .. max .. ")"
    end

    message = message .. ":"

    self._charSpace:write(1, 1 + self._numEntered, message)

    local input = Kevlar.Sync.Input.new(self._charSpace:sub(#message + 2, self._numEntered + 1, "*", 1))
    local value = nil

    while (value == nil or(min ~= nil and value < min) or(max ~= nil and value > max)) do
        value = tonumber(input:read())
    end

    self._numEntered = self._numEntered + 1

    return value
end

function Wizard:getString(message)
    message = message or "Text"
    message = message .. ":"

    local value = nil
    self._charSpace:write(1, 1 + self._numEntered, message)
    local input = Kevlar.Sync.Input.new(self._charSpace:sub(#message + 2, self._numEntered + 1, "*", 1))
    self._numEntered = self._numEntered + 1

    return input:read()
end

function Wizard:getVector(message)
    message = message or "Vector"
    message = message .. " (x,y,z):"

    local line = self._numEntered * 2
    if (line == 0) then
        line = 1
    end

    local value = nil
    self._charSpace:write(1, 1 + self._numEntered, message)
    local input = Kevlar.Sync.Input.new(self._charSpace:sub(1, line + 1, "*", 1))

    while (value == nil) do
        local values = string.split(input:read(), ",")
        local x = tonumber(values[1])
        local y = tonumber(values[2])
        local z = tonumber(values[3])

        if (x ~= nil and y ~= nil and z ~= nil) then
            value = Core.Vector.new(x, y, z)
        end
    end

    self._numEntered = self._numEntered + 1

    return value
end

function Wizard:getBool(message)
    message = message or "Boolean"
    message = message .. " (y/n):"

    local y = self._numEntered * 2
    if (y == 0) then
        y = 1
    end
    local input = Kevlar.Sync.Input.new(self._charSpace:sub(1, y + 1, "*", 1))
    self._charSpace:write(1, 1 + self._numEntered, message)
    self._numEntered = self._numEntered + 1

    local value = nil

    while (true) do
        value = input:read()
        if (value == "y") then return true end
        if (value == "n") then return false end
    end

    return value
end

function Wizard:getChoice(message, choices)
    self:printDashLine()

    local choicesStr = ""

    for i = 1, #choices do
        choicesStr = choicesStr .. choices[i]

        if (i ~= #choices) then
            choicesStr = choicesStr .. ", "
        end
    end

    print(message .. " (" .. choicesStr .. ")")
    local value = nil

    while (true) do
        value = string.lower(read())

        for i = 1, #choices do
            if (string.lower(choices[i]) == value) then
                return choices[i]
            end
        end
    end

end
--- <summary>instance: (Kevlar.Wizard)</summary>
--- <returns type="Kevlar.Sync.Wizard"></returns>
function Wizard.cast(instance)
    return instance
end

if (Kevlar == nil) then Kevlar = { } end
if (Kevlar.Sync == nil) then Kevlar.Sync = { } end
Kevlar.Sync.Wizard = Wizard