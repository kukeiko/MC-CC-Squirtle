local DigLineTask = {
    name = "Bulldoze.DigLine"
}

DigLineTask.Options = {
    direction = nil,
    length = nil,
    returnToOrigin = nil,
    digLeft = nil,
    digRight = nil,
    digTopOrFront = nil,
    digBottomOrBack = nil
}

--- <summary>
--- </summary>
--- <returns type="Bulldoze.DigLineTask"></returns>
function DigLineTask.new(kernel, opts)
    local instance = { }
    setmetatable(instance, { __index = DigLineTask })
    instance:ctor(kernel, opts)

    return instance
end

function DigLineTask:ctor(kernel, opts)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._turtle = Squirtle.Turtle.as(self._kernel:getUnit())

    self._opts = self.asOptions(opts)
end

function DigLineTask:run()
    local turtle = Squirtle.Turtle.as(self._kernel:getUnit())

    if (Core.Direction.isUpOrDown(self._opts.direction)) then
        self:_digUpOrDown()
    else
        self:_digFront()
        --        turtle:turnToOrientation(self._opts.direction)
        --        turtle:moveAggressive(Core.Side.Front, self._opts.length)

        --        if (self._opts.returnToOrigin) then
        --            turtle:turn(Core.Side.Left, 2)
        --            turtle:moveAggressive(Core.Side.Front, self._opts.length)
        --        end
    end
end

function DigLineTask:_digFront()
    local turtle = Squirtle.Turtle.as(self._kernel:getUnit())

    local digUp = self._opts.digTopOrFront
    local digDown = self._opts.digBottomOrBack

    local flags = {
        [Core.Side.Top] = self._opts.digTopOrFront == true,
        [Core.Side.Right] = self._opts.digRight == true,
        [Core.Side.Bottom] = self._opts.digBottomOrBack == true,
        [Core.Side.Left] = self._opts.digLeft == true
    }

    local numTrue = 0

    for k, v in pairs(flags) do
        if (v == true) then
            numTrue = numTrue + 1
        end
    end

    local digUpAndDown = function()
        if (digUp) then turtle:digTop() end
        if (digDown) then turtle:digBottom() end
    end

    local digAuxHandler = function() end
    local afterFirstPhase = nil
    local afterSecondPhase = nil

    if (self._opts.digLeft and self._opts.digRight) then
        if (self._opts.returnToOrigin) then
            digAuxHandler = function()
                digUpAndDown()

                turtle:turnLeft()
                turtle:dig()
                turtle:turnRight()
            end

            afterFirstPhase = function()
                turtle:turnRight()
                turtle:moveAggressive()
                turtle:turnRight()
            end

            afterSecondPhase = function()
                turtle:turnRight()
                turtle:moveAggressive()
                turtle:turnLeft()
            end
        else
            digAuxHandler = function()
                digUpAndDown()

                turtle:turnLeft()
                turtle:dig()
                turtle:turnRight(2)
                turtle:dig()
                turtle:turnLeft()
            end
        end
    elseif (self._opts.digLeft or self._opts.digRight) then
        local side = Core.Side.Left
        if (self._opts.digRight) then side = Core.Side.Right end

        if (self._opts.returnToOrigin) then
            afterFirstPhase = function()
                turtle:turn(side)
                turtle:moveAggressive()
                turtle:turn(side)
            end

            afterSecondPhase = function()
                turtle:turn(side)
                turtle:moveAggressive()
                turtle:turn((side + 2) % 4)
            end
        else
            digAuxHandler = function()
                digUpAndDown()

                turtle:turn(side)
                turtle:dig()
                turtle:turn((side + 2) % 4)
            end
        end
    else
        digAuxHandler = digUpAndDown

        afterFirstPhase = function()
            turtle:turnLeft(2)
        end
    end

    turtle:turnToOrientation(self._opts.direction)
    turtle:moveAggressive(Core.Side.Front, self._opts.length, digAuxHandler)

    if (self._opts.returnToOrigin) then
        if (afterFirstPhase) then
            afterFirstPhase()
        end

        turtle:moveAggressive(Core.Side.Front, self._opts.length - 1)

        if (afterSecondPhase) then
            afterSecondPhase()
        end

        turtle:moveAggressive(Core.Side.Front)
    end
end

function DigLineTask:_digUpOrDown()
    local turtle = Squirtle.Turtle.as(self._kernel:getUnit())

    local flags = {
        [Core.Side.Front] = self._opts.digTopOrFront == true,
        [Core.Side.Right] = self._opts.digRight == true,
        [Core.Side.Back] = self._opts.digBottomOrBack == true,
        [Core.Side.Left] = self._opts.digLeft == true
    }

    local numTrue = 0
    local first
    local hadConsecutive = false

    for i = 0, 3 do
        if (flags[i] == true) then
            numTrue = numTrue + 1

            if (not hadConsecutive and flags[(i + 1) % 4] == true) then
                hadConsecutive = true

                if (first == nil) then
                    first = i
                end
            end
        end
    end

    local digAuxHandler = function() end
    local digWhileReturning = false
    local firstPhaseEndingSide = nil

    if (numTrue == 4) then
        digAuxHandler = function()
            turtle:dig()
            turtle:turnLeft()
            turtle:dig()
            turtle:turnLeft()
            turtle:dig()
            turtle:turnLeft()
            turtle:dig()
            turtle:turnLeft()
        end
    elseif (numTrue == 3) then
        turtle:turnToSide(first)

        local turnSide = Core.Side.Right

        digAuxHandler = function()
            turtle:dig()
            turtle:turn(turnSide)
            turtle:dig()
            turtle:turn(turnSide)
            turtle:dig()

            if (turnSide == Core.Side.Right) then
                turnSide = Core.Side.Left
            else
                turnSide = Core.Side.Right
            end
        end
    elseif (numTrue == 2) then
        if (hadConsecutive) then
            turtle:turnToSide(first)

            local turnSide = Core.Side.Right

            if (self._opts.returnToOrigin) then
                digWhileReturning = true
                firstPhaseEndingSide = Core.Side.Right

                digAuxHandler = function()
                    turtle:dig()
                end
            else
                digAuxHandler = function()
                    turtle:dig()
                    turtle:turn(turnSide)
                    turtle:dig()

                    if (turnSide == Core.Side.Right) then
                        turnSide = Core.Side.Left
                    else
                        turnSide = Core.Side.Right
                    end
                end
            end
        else
            if (self._opts.digRight and self._opts.digLeft) then
                turtle:turnRight()
            end

            if (self._opts.returnToOrigin) then
                digWhileReturning = true
                firstPhaseEndingSide = Core.Side.Back

                digAuxHandler = function()
                    turtle:dig()
                end
            else
                digAuxHandler = function()
                    turtle:dig()
                    turtle:turnRight(2)
                    turtle:dig()
                end
            end
        end
    elseif (numTrue == 1) then
        for k, v in ipairs(flags) do
            if (v) then turtle:turnToSide(k) end
        end

        digAuxHandler = function()
            turtle:dig()
        end
    end

    if (self._opts.direction == Core.Direction.Up) then
        turtle:moveAggressive(Core.Direction.Up, self._opts.length, digAuxHandler)

        if (self._opts.returnToOrigin and digWhileReturning) then
            if (firstPhaseEndingSide ~= nil) then
                turtle:turnToSide(firstPhaseEndingSide)
            end

            digAuxHandler()
            turtle:moveAggressive(Core.Direction.Down, self._opts.length - 1, digAuxHandler)
            turtle:moveAggressive(Core.Direction.Down)
        elseif (self._opts.returnToOrigin) then
            turtle:moveAggressive(Core.Direction.Down, self._opts.length)
        end
    else
        turtle:moveAggressive(Core.Direction.Down, self._opts.length, digAuxHandler)

        if (self._opts.returnToOrigin and digWhileReturning) then
            if (firstPhaseEndingSide ~= nil) then
                turtle:turnToSide(firstPhaseEndingSide)
            end

            digAuxHandler()
            turtle:moveAggressive(Core.Direction.Up, self._opts.length - 1, digAuxHandler)
            turtle:moveAggressive(Core.Direction.Up)
        elseif (self._opts.returnToOrigin) then
            turtle:moveAggressive(Core.Direction.Up, self._opts.length)
        end
    end
end

--- <summary></summary>
--- <returns type="Bulldoze.DigLineTask"></returns>
function DigLineTask.as(instance) return instance end

--- <summary></summary>
--- <returns type="Bulldoze.DigLineTask.Options"></returns>
function DigLineTask.asOptions(instance)
    return instance
end

Bulldoze = Bulldoze or { }
Bulldoze.DigLineTask = DigLineTask

if (turtle) then
    Squirtle = Squirtle or { }
    Squirtle.Tasks = Squirtle.Tasks or { }
    Squirtle.Tasks[DigLineTask.name] = DigLineTask
end
