local Turtle = {
    _instance = nil
}

--- <summary>
--- </summary>
--- <returns type="Squirtle.Turtle"></returns>
function Turtle.new()
    if (not turtle) then error("Not a turtle") end

    local instance = Squirtle.Unit.new()
    setmetatable(Turtle, { __index = Squirtle.Unit })
    setmetatable(instance, { __index = Turtle })
    instance:ctor()

    return instance
end

function Turtle:ctor()
    self._em = Core.EventManager.new()
end

function Turtle:load()
    Squirtle.Unit.load(self)

    self._turtleApi = Squirtle.TurtleApi.new()
    self._peripherals = Squirtle.Peripherals.new()
    self._inventory = Squirtle.Inventory.new(self._turtleApi)
    self._equipment = Squirtle.Equipment.new(self._turtleApi, self._inventory, self._peripherals)
    self._fueling = Squirtle.Fueling.new(self._turtleApi, self._inventory)

    self._inventory:reserve("minecraft:diamond_pickaxe")
    self._inventory:reserve("minecraft:compass")
    self._inventory:condense()
    self._equipment:load()

    local address = "Turtle:" .. self:base():getDeviceId()
    local modem, side = self._equipment:equipAndLock("chunkyperipherals:WirelessChunkyModuleItem")
    self._wirelessAdapter = Unity.Adapter.new(address, modem, side)

    local compass = self._equipment:equip("minecraft:compass")

    -- todo: what a hack!
    self._orientation = compass.getFacing()
    self._orientation = Core.Direction[string.upper(self._orientation:sub(1, 1)) .. self._orientation:sub(2)]
    self._location = self:getLiveLocation()

    local updateLocation = function(side)
        local orientation = self:sideToOrientation(side)
        local delta = Core.Direction.Deltas[orientation]

        self._location = self._location + delta
    end

    self._turtleApi:on("forward", function() updateLocation(Core.Side.Front) end)
    self._turtleApi:on("back", function() updateLocation(Core.Side.Back) end)
    self._turtleApi:on("up", function() updateLocation(Core.Side.Top) end)
    self._turtleApi:on("down", function() updateLocation(Core.Side.Bottom) end)

    self._turtleApi:on("turnLeft", function()
        self._orientation = self._orientation - 1
        self._orientation = self._orientation % 4
    end )

    self._turtleApi:on("turnRight", function()
        self._orientation = self._orientation + 1
        self._orientation = self._orientation % 4
    end )
end

function Turtle:getInventory()
    return self._inventory
end

function Turtle:getEquipment()
    return self._equipment
end

function Turtle:getFueling()
    return self._fueling
end

function Turtle:getWirelessAdapter()
    return self._wirelessAdapter
end

function Turtle:getTurtleApi()
    return self._turtleApi
end

function Turtle:getOrientation()
    return self._orientation
end

function Turtle:getLocation()
    return self._location
end

function Turtle:getLiveLocation()
    local location = self:tryGetLiveLocation()

    if (location == nil) then
        error("Location:getLiveLocation(): GPS dead")
    end

    return location
end

function Turtle:tryGetLiveLocation()
    local x, y, z = gps.locate(1)

    if (not x) then return nil end

    if (x < 0) then x = math.ceil(x) else x = math.floor(x) end
    if (z < 0) then z = math.ceil(z) else z = math.floor(z) end

    y = math.ceil(y)

    if (pocket) then
        y = y - 2
    end

    return Core.Vector.new(x, y, z)
end

function Turtle:sideToOrientation(side)
    if (side == Core.Side.Top) then return Core.Direction.Up end
    if (side == Core.Side.Bottom) then return Core.Direction.Down end

    return(self:getOrientation() + side) % 4
end

function Turtle:currentChunkOrigin()
    local loc = self:getLocation()
    local relativeX = loc.x % 16
    local relativeZ = loc.z % 16

    return(Core.Vector.new(relativeX, 0, relativeZ) * -1) + self:getLocation()
end

function Turtle:deltaToChunkCenter()
    local loc = self:getLocation()
    local relativeX = loc.x % 16
    local relativeZ = loc.z % 16

    return Core.Vector.new(7 - relativeX, 0, 7 - relativeZ)
end

function Turtle:equipPickaxe()
    self._equipment:equip("minecraft:diamond_pickaxe")
end

function Turtle:attack(side)
    side = side or Core.Side.Front

    self:equipPickaxe()

    local success, e = self._turtleApi:attack(side)

    if (not success and e ~= "Nothing to attack here") then
        error("Mining:attack: failed to attack: " .. e)
    end

    return success
end

function Turtle:attackStrict(side)
    direction = direction or Core.Side.Front

    self:equipPickaxe()

    local success, e = self._turtleApi:attack(side)

    if (not success) then
        error("Mining:attack: failed to attack: " .. e)
    end

    return success
end

function Turtle:dig(side)
    direction = direction or Core.Side.Front

    self:equipPickaxe()

    local success, e = self._turtleApi:dig(side)

    if (not success and e ~= "Nothing to dig here") then
        error("Mining:dig: failed to dig: " .. e)
    end

    return success
end

function Turtle:digStrict(side)
    direction = direction or Core.Side.Front

    self:equipPickaxe()

    local success, e = self._turtleApi:dig(side)

    if (not success) then
        error("Mining:dig: failed to dig: " .. e)
    end
end

function Turtle:turn(side, times)
    times = times or 1

    for i = 1, times do
        self._turtleApi:turn(side)
    end
end

function Turtle:turnToOrientation(orientation)
    if (orientation == Core.Direction.Up or orientation == Core.Direction.Down) then return false end

    local current = self:getOrientation()
    local rightTurns =(orientation + 4 - current) % 4
    local leftTurns = math.abs(orientation - 4 - current) % 4

    if (leftTurns < rightTurns) then
        self:turn(Core.Side.Left, leftTurns)
    else
        self:turn(Core.Side.Right, rightTurns)
    end
end

function Turtle:movePeaceful(side, times)
    local success, stepsMoved, e = self:tryMovePeaceful(side, times)

    if (not success) then
        error(e)
    end

    return stepsMoved
end

function Turtle:tryMovePeaceful(side, times)
    times = times or 1

    self:getFueling():refuel(times)

    for i = 1, times do
        local success, e = self._turtleApi:move(side)
        if (not success) then return false, i - 1, e end
    end

    return true, times
end

function Turtle:moveAggressive(side, times)
    times = times or 1

    self:getFueling():refuel(times)
    local success = false

    for i = 1, times do
        while (not success) do
            success, e = self._turtleApi:move(side)

            if (not success) then
                if (self._turtleApi:detect(side)) then
                    self:dig(side)
                else
                    self:attack()
                end
            end
        end

        success = false
    end
end

function Turtle:moveToAggressive(point)
    local loc = self:getLocation()
    local delta = point - loc

    if (delta.y > 0) then
        self:moveAggressive(Core.Direction.Up, delta.y)
    elseif (delta.y < 0) then
        self:moveAggressive(Core.Direction.Down, delta.y * -1)
    end

    if (delta.x > 0) then
        self:turnToOrientation(Core.Direction.East)
        self:moveAggressive(Core.Side.Front, delta.x)
    elseif (delta.x < 0) then
        self:turnToOrientation(Core.Direction.West)
        self:moveAggressive(Core.Side.Front, delta.x * -1)
    end

    if (delta.z > 0) then
        self:turnToOrientation(Core.Direction.South)
        self:moveAggressive(Core.Side.Front, delta.z)
    elseif (delta.z < 0) then
        self:turnToOrientation(Core.Direction.North)
        self:moveAggressive(Core.Side.Front, delta.z * -1)
    end
end

function Turtle:tryWalkPathPeaceful(path)
    if (#path == 0) then return true, 0 end

    local success
    self:getFueling():refuel(#path)

    for k, v in ipairs(path) do
        local delta = v - self:getLocation()

        if (delta.x > 0) then
            self:turnToOrientation(Core.Direction.East)
            success = self:tryMovePeaceful(Core.Side.Front, delta.x)
        elseif (delta.x < 0) then
            self:turnToOrientation(Core.Direction.West)
            success = self:tryMovePeaceful(Core.Side.Front, delta.x * -1)
        elseif (delta.y > 0) then
            success = self:tryMovePeaceful(Core.Direction.Up, delta.y)
        elseif (delta.y < 0) then
            success = self:tryMovePeaceful(Core.Direction.Down, delta.y * -1)
        elseif (delta.z > 0) then
            self:turnToOrientation(Core.Direction.South)
            success = self:tryMovePeaceful(Core.Side.Front, delta.z)
        elseif (delta.z < 0) then
            self:turnToOrientation(Core.Direction.North)
            success = self:tryMovePeaceful(Core.Side.Front, delta.z * -1)
        end

        if (not success) then
            break
        end
    end

    return success
end

function Turtle:walkPathAggressive(path)
    if (#path == 0) then return true, 0 end

    self:getFueling():refuel(#path)

    for k, v in ipairs(path) do
        local delta = v - self:getLocation()

        if (delta.x > 0) then
            self:turnToOrientation(Core.Direction.East)
            self:moveAggressive(Core.Side.Front, delta.x)
        elseif (delta.x < 0) then
            self:turnToOrientation(Core.Direction.West)
            self:moveAggressive(Core.Side.Front, delta.x * -1)
        elseif (delta.y > 0) then
            self:moveAggressive(Core.Direction.Up, delta.y)
        elseif (delta.y < 0) then
            self:moveAggressive(Core.Direction.Down, delta.y * -1)
        elseif (delta.z > 0) then
            self:turnToOrientation(Core.Direction.South)
            self:moveAggressive(Core.Side.Front, delta.z)
        elseif (delta.z < 0) then
            self:turnToOrientation(Core.Direction.North)
            self:moveAggressive(Core.Side.Front, delta.z * -1)
        end
    end
end

function Turtle:navigateTo(target)
    local world = { }
    local points = { }

    local scan = function()
        if (self._turtleApi:detect(Core.Side.Top)) then
            local point = self:getLocation() + Core.Vector.new(0, 1, 0)
            world[point:toString()] = point
        end

        if (self._turtleApi:detect(Core.Side.Front)) then
            local point = self:getLocation() + Core.Direction.Deltas[self:getOrientation()]
            world[point:toString()] = point
        end

        if (self._turtleApi:detect(Core.Side.Bottom)) then
            local point = self:getLocation() + Core.Vector.new(0, -1, 0)
            world[point:toString()] = point
        end
    end

    local i = 1

    while (true) do
        scan()

        local thread = Core.Thread.new( function()
            return Core.Pathing.aStarPruning(world, self:getLocation(), target, self:getOrientation())
        end )

        local success, path = thread:runSync()

        if (success == false) then
            error(path)
        end

        if (path == nil) then
            error("no path found")
        end

        if (self:tryWalkPathPeaceful(path)) then
            break
        end
    end
end

--- <summary>instance: (Squirtle.Turtle)</summary>
--- <returns type="Squirtle.Turtle"></returns>
function Turtle.as(instance)
    return instance
end

--- <summary>
--- </summary>
--- <returns type="Squirtle.Unit"></returns>
function Turtle:base()
    return self
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Turtle = Turtle