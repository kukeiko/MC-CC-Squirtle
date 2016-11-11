local Waypoints = { }

function Waypoints.new(unit, charSpace)
    local instance = { }
    setmetatable(instance, { __index = Waypoints })

    instance:ctor(unit, charSpace)

    return instance
end

function Waypoints:ctor(unit, charSpace)
    self._unit = Squirtle.Unit.as(unit)
    self._charSpace = Kevlar.ICharSpace.as(charSpace)
end

function Waypoints:run()
    local header = Kevlar.Header.new("Waypoints", "-", self._charSpace:sub(1, 1, "*", 1))
    header:draw()

    Core.MessagePump.pull("key")
end

if (Scout == nil) then Scout = { } end
if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Scout.Waypoints = Waypoints
Squirtle.Waypoints = Waypoints
Squirtle.Apps.Waypoints = Waypoints