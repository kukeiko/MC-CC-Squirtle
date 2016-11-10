local Tablet = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.Tablet"></returns>
function Tablet.new()
    local instance = Squirtle.Unit.new()

    setmetatable(Tablet, { __index = Squirtle.Unit })
    setmetatable(instance, { __index = Tablet })

    return instance
end

--- <summary>
--- Helper for BabeLua autocomplete
--- </summary>
--- <returns type="Squirtle.Unit"></returns>
function Tablet:base() return self end

function Tablet:load()
    Squirtle.Unit.load(self)
    
    local address = "Tablet:" .. self:base():getDeviceId()
    self._wirelessAdapter = Unity.Adapter.new(address, peripheral.wrap("back"), Core.Side.Back)
end

function Tablet:getWirelessAdapter()
    return self._wirelessAdapter
end

function Tablet:getLocation()
    local x, y, z = gps.locate(1)

    if (not x) then error("GPS dead") end

    if (x < 0) then x = math.ceil(x) else x = math.floor(x) end
    if (z < 0) then z = math.ceil(z) else z = math.floor(z) end

    y = math.ceil(y)

    if (pocket) then
        y = y - 2
    end

    return Core.Vector.new(x, y, z)
end

--- <summary>instance: (Squirtle.Tablet)</summary>
--- <returns type="Squirtle.Tablet"></returns>
function Tablet.as(instance)
    return instance
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Tablet = Tablet