local Unit = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.Unit"></returns>
function Unit.new()
    local instance = { }
    setmetatable(instance, { __index = Unit })
    instance:ctor()

    return instance
end

function Unit:ctor()
end

--- <summary> instance: (Squirtle.Unit) </summary>
--- <returns type="Squirtle.Unit"></returns>
function Unit.as(instance) return instance end

function Unit:load() end

function Unit:getDeviceId()
    return os.getComputerID()
end

function Unit:isComputer()
    return not self:isTurtle() and not self:isPocket()
end

function Unit:isTurtle()
    return turtle ~= nil
end

function Unit:isPocket()
    return pocket ~= nil
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Unit = Unit