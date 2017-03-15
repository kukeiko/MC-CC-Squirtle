local TurtleApi = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.TurtleApi"></returns>
function TurtleApi.new(turtle, equipment)
    local instance = { }
    setmetatable(instance, { __index = TurtleApi })
    instance:ctor(turtle, equipment)

    return instance
end

--- <summary>
--- </summary>
--- <returns type="Squirtle.TurtleApi"></returns>
function TurtleApi.as(instance)
    return instance
end

function TurtleApi:ctor(turtle, equipment)
    self._em = Core.EventManager.new()
end

function TurtleApi:call(funcName)
    local success, e = turtle[funcName]()
    if (success) then self._em:raise(funcName) end

    return success, e
end

function TurtleApi:on(funcName, handler)
    return self._em:on(funcName, handler)
end

function TurtleApi:turn(side)
    local fnName

    if (side == Core.Side.Left) then
        fnName = "turnLeft"
    elseif (side == Core.Side.Right) then
        fnName = "turnRight"
    else
        error("TurtleApi:turn(): invalid arg, expected Core.Side.Left / Core.Side.Right")
    end

    return self:call(fnName)
end

function TurtleApi:move(side)
    side = side or Core.Side.Front

    local fnName

    if (side == Core.Side.Front) then
        fnName = "forward"
    elseif (side == Core.Side.Top) then
        fnName = "up"
    elseif (side == Core.Side.Bottom) then
        fnName = "down"
    elseif (side == Core.Side.Back) then
        fnName = "back"
    else
        error("TurtleApi:move(): invalid arg, expected Core.Side.Front, Core.Side.Top, Core.Side.Bottom, Core.Side.Back")
    end

    return self:call(fnName)
end

function TurtleApi:equip(side)
    local fnName

    if (side == Core.Side.Left) then
        fnName = "equipLeft"
    elseif (side == Core.Side.Right) then
        fnName = "equipRight"
    else
        error("TurtleApi:equip(): invalid arg, expected Core.Side.Left / Core.Side.Right")
    end

    return self:call(fnName)
end

function TurtleApi:attack(side)
    side = side or Core.Side.Front

    local fnName

    if (side == Core.Side.Front) then
        fnName = "attack"
    elseif (side == Core.Side.Top) then
        fnName = "attackUp"
    elseif (side == Core.Side.Bottom) then
        fnName = "attackDown"
    else
        error("TurtleApi:attack(): invalid arg, expected Core.Side.Front, Core.Side.Top, Core.Side.Bottom")
    end

    return self:call(fnName)
end

function TurtleApi:detect(side)
    side = side or Core.Side.Front

    local fnName

    if (side == Core.Side.Front) then
        fnName = "detect"
    elseif (side == Core.Side.Top) then
        fnName = "detectUp"
    elseif (side == Core.Side.Bottom) then
        fnName = "detectDown"
    else
        error("TurtleApi:detect(): invalid arg, expected Core.Side.Front, Core.Side.Top, Core.Side.Bottom")
    end

    return self:call(fnName)
end

function TurtleApi:place(side)
    side = side or Core.Side.Front

    local fnName

    if (side == Core.Side.Front) then
        fnName = "place"
    elseif (side == Core.Side.Top) then
        fnName = "placeUp"
    elseif (side == Core.Side.Bottom) then
        fnName = "placeDown"
    else
        error("TurtleApi:place(): invalid arg, expected Core.Side.Front, Core.Side.Top, Core.Side.Bottom")
    end

    return self:call(fnName)
end

function TurtleApi:drop(side)
    side = side or Core.Side.Front

    local fnName

    if (side == Core.Side.Front) then
        fnName = "drop"
    elseif (side == Core.Side.Top) then
        fnName = "dropUp"
    elseif (side == Core.Side.Bottom) then
        fnName = "dropDown"
    else
        error("TurtleApi:drop(): invalid arg, expected Core.Side.Front, Core.Side.Top, Core.Side.Bottom")
    end

    return self:call(fnName)
end

function TurtleApi:inspect(side)
    side = side or Core.Side.Front

    local fnName

    if (side == Core.Side.Front) then
        fnName = "inspect"
    elseif (side == Core.Side.Top) then
        fnName = "inspectUp"
    elseif (side == Core.Side.Bottom) then
        fnName = "inspectDown"
    else
        error("TurtleApi:inspect(): invalid arg, expected Core.Side.Front, Core.Side.Top, Core.Side.Bottom")
    end

    return self:call(fnName)
end

function TurtleApi:dig(side)
    side = side or Core.Side.Front

    local fnName

    if (side == Core.Side.Front) then
        fnName = "dig"
    elseif (side == Core.Side.Top) then
        fnName = "digUp"
    elseif (side == Core.Side.Bottom) then
        fnName = "digDown"
    else
        error("TurtleApi:dig(): invalid arg, expected Core.Side.Front, Core.Side.Top, Core.Side.Bottom")
    end

    return self:call(fnName)
end

function TurtleApi:getFuelLimit()
    return turtle.getFuelLimit()
end

function TurtleApi:getFuelLevel()
    return turtle.getFuelLevel()
end

function TurtleApi:refuel(num)
    return turtle.refuel(num)
end

function TurtleApi:getItemCount(slot)
    return turtle.getItemCount(slot)
end

function TurtleApi:getItemSpace(slot)
    return turtle.getItemSpace(slot)
end

function TurtleApi:getMissingQuantity(slot)
    return turtle.getMissingQuantity(slot)
end

function TurtleApi:getItemDetail(slot)
    return turtle.getItemDetail(slot)
end

function TurtleApi:select(slot)
    return turtle.select(slot)
end

function TurtleApi:transferTo(toSlot, quantity)
    return turtle.transferTo(toSlot, quantity)
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.TurtleApi = TurtleApi