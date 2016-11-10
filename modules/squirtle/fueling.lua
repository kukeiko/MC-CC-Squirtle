local Fueling = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.Fueling"></returns>
function Fueling.new(turtleApi, inventory)
    local instance = { }
    setmetatable(instance, { __index = Fueling })
    instance:ctor(turtleApi, inventory)

    return instance
end

--- <summary>
--- </summary>
--- <returns type="Squirtle.Fueling"></returns>
function Fueling.as(instance)
    return instance
end

function Fueling:ctor(turtleApi, inventory)
    self._turtleApi = Squirtle.TurtleApi.as(turtleApi)
    self._inventory = Squirtle.Inventory.as(inventory)

    self._isUnlimitedMode = self._turtleApi:getFuelLimit() == "unlimited"
    self._fuelItemIds = {
        "minecraft:lava_bucket",
        "minecraft:coal_block",
        "minecraft:coal"
    }
end

function Fueling:isUnlimitedMode()
    return self._isUnlimitedMode
end

function Fueling:getFuelLevel()
    return self._turtleApi:getFuelLevel()
end

function Fueling:getFuelLimit()
    return self._turtleApi:getFuelLimit()
end

function Fueling:getLevelToFull()
    if (self:isUnlimitedMode()) then return 0 end

    return self:getFuelLimit() - self:getFuelLevel()
end

function Fueling:isFull()
    if (self:isUnlimitedMode()) then return true end

    return self:getFuelLevel() == self:getFuelLimit()
end

function Fueling:hasFuel(num)
    if (self:isUnlimitedMode()) then return true end

    num = num or 1

    return self:getFuelLevel() >= num
end

function Fueling:getFuelItemIds()
    return self._fuelItemIds
end

function Fueling:refuel(toFuelLevel)
    if (self:isUnlimitedMode()) then return nil end

    toFuelLevel = toFuelLevel or 1

    if (self:getFuelLevel() >= toFuelLevel) then
        return nil
    end

    if (toFuelLevel > self:getFuelLimit()) then
        error("required refuel level is bigger than fuel limit")
    end

    for k, fuelId in pairs(self:getFuelItemIds()) do
        while(self:getFuelLevel() < toFuelLevel) do
            local slot = self._inventory:findItem(fuelId)

            if(slot) then
                self._inventory:select(slot)
                self._turtleApi:refuel(1)
            else
                break
            end
        end

        if(self:getFuelLevel() >= toFuelLevel) then
            return nil
        end
    end

    error("failed to reach required fuel level")
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Fueling = Fueling