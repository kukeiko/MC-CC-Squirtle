local Waypoints = { }

function Waypoints.new(unit, buffer)
    local instance = { }
    setmetatable(instance, { __index = Waypoints })

    instance:ctor(unit, buffer)

    return instance
end

function Waypoints:ctor(unit, buffer)
    self._unit = Squirtle.Unit.as(unit)
    self._buffer = Kevlar.IBuffer.as(buffer)
end

function Waypoints:run()
    local header = Kevlar.Header.new("Waypoints", "-", self._buffer:sub(1, 1, "*", 1))
    header:draw()

    Core.MessagePump.pull("key")
end

if (Scout == nil) then Scout = { } end
if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Scout.Waypoints = Waypoints
Squirtle.Waypoints = Waypoints
Squirtle.Apps.Waypoints = Waypoints