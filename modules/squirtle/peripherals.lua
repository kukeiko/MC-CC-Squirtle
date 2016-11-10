local Peripherals = {}

--- <summary>
--- </summary>
--- <returns type="Squirtle.Peripherals"></returns>
function Peripherals.new()
    local instance = {}
    setmetatable(instance, { __index = Peripherals })

    instance:ctor()

    return instance
end

--- <summary>
--- </summary>
--- <returns type="Squirtle.Peripherals"></returns>
function Peripherals.as(instance)
    return instance
end

function Peripherals:ctor()
end

function Peripherals:isPresent(side)
    return peripheral.isPresent(string.lower(Core.Side[side]))
end

function Peripherals:getType(side)
    return peripheral.getType(string.lower(Core.Side[side]))
end

function Peripherals:wrap(side)
    return peripheral.wrap(string.lower(Core.Side[side]))
end

if(Squirtle == nil) then Squirtle = {} end
Squirtle.Peripherals = Peripherals