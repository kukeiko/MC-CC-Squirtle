local Pathing = { }
local self = Pathing

function Pathing.manhattan(v0, v1)
    return math.abs(v1.x - v0.x) + math.abs(v1.y - v0.y) + math.abs(v1.z - v0.z)
end

function Pathing.aStar(world, start, goal, orientation)
    if (world[goal:toString()] ~= nil) then return nil end

    orientation = orientation or Core.Direction.South

    local open = { }
    local numOpen = 0
    local closed = { }
    local map = { }
    local pastCost = { }
    local futureCost = { }
    local totalCost = { }
    local estimatedSteps = self.manhattan(start, goal)
    local heuristic = self.manhattan
    local startKey = start:toString()

    open[startKey] = start
    pastCost[startKey] = 0
    futureCost[startKey] = heuristic(start, goal)
    totalCost[startKey] = pastCost[startKey] + futureCost[startKey]
    numOpen = numOpen + 1

    while (numOpen > 0) do
        local lowestF = nil
        local current = nil
        local currentKey = nil

        for k, v in pairs(open) do
            if (lowestF == nil or totalCost[k] < lowestF) then
                current = v
                currentKey = k
                lowestF = totalCost[k]
            end
        end

        if (vector.equals(current, goal)) then
            local path = { }
            local pathVector = goal

            while (not vector.equals(pathVector, start)) do
                table.insert(path, pathVector)
                pathVector = map[pathVector:toString()]
            end

            local revPath = { }

            for k, v in pairs(path) do
                table.insert(revPath, 1, v)
            end

            return revPath
        end

        open[currentKey] = nil
        closed[currentKey] = current
        numOpen = numOpen - 1

        if (map[currentKey]) then
            local delta = current - map[currentKey]
            orientation = Core.Direction.Deltas[delta:toString()]
        end

        local neighbours = { }

        for i = 0, #ORIENTATION_DELTAS do
            local neighbour = current + ORIENTATION_DELTAS[i]
            local neighbourKey = neighbour:toString()
            local requiresTurn = false

            if (i ~= orientation and i ~= Core.Direction.Up and i ~= Core.Direction.Down) then
                requiresTurn = true
            end

            if (closed[neighbourKey] == nil and world[neighbourKey] == nil) then
                local tentativePastCost = pastCost[currentKey] + 1

                if (requiresTurn) then
                    tentativePastCost = tentativePastCost + 1
                end

                if (open[neighbourKey] == nil or tentativePastCost < pastCost[neighbourKey]) then
                    pastCost[neighbourKey] = tentativePastCost

                    local neighbourFutureCost = heuristic(neighbour, goal)

                    -- future turn costs
                    if (neighbour.x ~= goal.x) then neighbourFutureCost = neighbourFutureCost + 1 end
                    if (neighbour.z ~= goal.z) then neighbourFutureCost = neighbourFutureCost + 1 end

                    futureCost[neighbourKey] = neighbourFutureCost
                    totalCost[neighbourKey] = pastCost[neighbourKey] + neighbourFutureCost

                    map[neighbourKey] = current

                    if (open[neighbourKey] == nil) then
                        open[neighbourKey] = neighbour
                        numOpen = numOpen + 1
                    end
                end
            end
        end

        --        coroutine.yield(numOpen, estimatedSteps)
    end

    return nil
end

function Pathing.aStarPruning(world, start, goal, orientation)
    if (world[goal:toString()] ~= nil) then return nil end

    orientation = orientation or Core.Direction.South

    local open = { }
    local numOpen = 0
    local closed = { }
    local map = { }
    local pastCost = { }
    local futureCost = { }
    local totalCost = { }
    local heuristic = self.manhattan
    local startKey = start:toString()
    local naturals = { }
    local forced = { }
    local pruned = { }

    local highestFutureCost = nil
    local lowestFutureCost = nil

    open[startKey] = start
    pastCost[startKey] = 0
    futureCost[startKey] = heuristic(start, goal)
    totalCost[startKey] = pastCost[startKey] + futureCost[startKey]
    numOpen = numOpen + 1

    local t = Kevlar.Terminal.new()
    local cycles = 1

    while (numOpen > 0) do
        t:write(1, t:getHeight(), numOpen .. "")
        local lowestF = nil
        local current = nil
        local currentKey = nil
        local currentType = nil
        cycles = cycles + 1

        if (cycles % 100 == 0) then
            local progress = math.ceil(math.abs((lowestFutureCost / highestFutureCost) -1) * 100)
            coroutine.yield(progress)
        end

        for k, v in pairs(open) do
            local thisType = 3
--            cycles = cycles + 1

            if (naturals[k]) then
                thisType = 0
            elseif (forced[k]) then
                thisType = 1
            elseif (pruned[k]) then
                thisType = 2
            end

            if (highestFutureCost == nil or futureCost[k] > highestFutureCost) then
                highestFutureCost = futureCost[k]
            end

            if (lowestFutureCost == nil or futureCost[k] < lowestFutureCost) then
                lowestFutureCost = futureCost[k]
            end

            if (lowestF == nil or totalCost[k] < lowestF) then
                current = v
                currentKey = k
                lowestF = totalCost[k]
                currentType = thisType
            elseif (totalCost[k] <= lowestF and thisType < currentType) then
                current = v
                currentKey = k
                lowestF = totalCost[k]
                currentType = thisType
            end
        end

        if (vector.equals(current, goal)) then
            local progress = math.ceil(math.abs((lowestFutureCost / highestFutureCost) -1) * 100)
            coroutine.yield(progress)

            local path = { }
            local pathVector = goal

            while (not vector.equals(pathVector, start)) do
                table.insert(path, pathVector)
                pathVector = map[pathVector:toString()]
            end

            local revPath = { }
            for k, v in pairs(path) do table.insert(revPath, 1, v) end

            -- print("[Naturals]: "..table.size(naturals))
            -- print("[Forced]: "..table.size(forced))
            -- print("[Pruned]: "..table.size(pruned))
            -- print("[Closed]: "..table.size(closed))

            return revPath
        end

        open[currentKey] = nil
        closed[currentKey] = current
        numOpen = numOpen - 1

        if (map[currentKey]) then
            local delta = current - map[currentKey]
            orientation = Core.Direction.Deltas[delta:toString()]
        end

        local neighbours = { }

        for i = 0, 5 do
            local neighbour = current + Core.Direction.Deltas[i]
            local neighbourKey = neighbour:toString()
            local requiresTurn = false

            if (i ~= orientation and(i ~= Core.Direction.Up or i ~= Core.Direction.Down)) then
                requiresTurn = true
            end

            if (closed[neighbourKey] == nil and world[neighbourKey] == nil) then
                local tentativePastCost = pastCost[currentKey] + 1

                if (requiresTurn) then
                    tentativePastCost = tentativePastCost + 1
                end

                if (open[neighbourKey] == nil or tentativePastCost < pastCost[neighbourKey]) then
                    pastCost[neighbourKey] = tentativePastCost

                    local neighbourFutureCost = heuristic(neighbour, goal)

                    if (neighbour.x ~= goal.x) then neighbourFutureCost = neighbourFutureCost + 1 end
                    if (neighbour.z ~= goal.z) then neighbourFutureCost = neighbourFutureCost + 1 end
                    if (neighbour.y ~= goal.y) then neighbourFutureCost = neighbourFutureCost + 1 end

                    futureCost[neighbourKey] = neighbourFutureCost
                    totalCost[neighbourKey] = pastCost[neighbourKey] + neighbourFutureCost

                    map[neighbourKey] = current

                    if (open[neighbourKey] == nil) then
                        open[neighbourKey] = neighbour
                        neighbours[i] = neighbour
                        numOpen = numOpen + 1
                    end
                end
            end
        end

        -- pruning
        if (map[currentKey] ~= nil) then
            for neighbourOrientation, neighbour in pairs(neighbours) do
                local neighbourKey = neighbour:toString()

                if (neighbourOrientation == orientation) then
                    -- add natural neighbour
                    naturals[neighbourKey] = neighbour
                else
                    -- check blockade
                    local check = map[currentKey] + Core.Direction.Deltas[neighbourOrientation] - Core.Direction.Deltas[orientation]
                    local checkKey = check:toString()

                    if (world[checkKey] == nil) then
                        -- add neighbour to prune
                        pruned[neighbourKey] = neighbour
                    else
                        -- add neighbour to forced
                        forced[neighbourKey] = neighbour
                    end
                end
            end
        end
    end

    return nil
end

if (Core == nil) then Core = { } end
Core.Pathing = Pathing
