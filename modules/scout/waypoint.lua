local Waypoint = { }

--- <summary></summary>
--- <returns type="Scout.Waypoint"></returns>
function Waypoint.new(name, location)
    local instance = { }
    setmetatable(instance, {
        __index = Waypoint,
        __tostring = Waypoint.toString,
        __concat = Waypoint.concat,
        __eq = Waypoint.equals
    })

    instance:ctor(name, location)

    return instance
end

function Waypoint:ctor(name, location)
    self.name = name
    self.location = Squirtle.Vector.as(location)
end

--- <summary>Sets necessary metatables.</summary>
--- <returns type="Scout.Waypoint"></returns>
function Waypoint.cast(instance)
    local wp = setmetatable(instance,
    {
        __index = Waypoint,
        __tostring = Waypoint.toString,
        __concat = Waypoint.concat,
        __eq = Waypoint.equals
    } )

    wp.location = Squirtle.Vector.cast(wp.location)

    return wp
end

--- <summary>Intellisense helper</summary>
--- <returns type="Scout.Waypoint"></returns>
function Waypoint.as(instance)
    return instance
end

function Waypoint:equals(other)
    return other.name == self.name
    and vector.equals(other.location, self.location)
end

function Waypoint:toString()
    return self.name .. " @ (" .. self.location .. ")"
end

function Waypoint:concat(other)
    return tostring(self) .. tostring(other)
end

if (Scout == nil) then Scout = { } end
Scout.Waypoint = Waypoint
