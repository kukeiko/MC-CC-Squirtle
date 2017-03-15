-- if the number of elements, order or assigned values of the side & direction enums are changed, a lot of functions will catch on fire.

local Side = {
    Front = 0,
    Right = 1,
    Back = 2,
    Left = 3,
    Top = 4,
    Bottom = 5,
    [0] = "Front",
    [1] = "Right",
    [2] = "Back",
    [3] = "Left",
    [4] = "Top",
    [5] = "Bottom"
}

if (not turtle) then
    Side.Right = 3
    Side.Left = 1
    Side[3] = "Right"
    Side[1] = "Left"
end

local Direction = {
    South = 0,
    West = 1,
    North = 2,
    East = 3,
    Up = 4,
    Down = 5,
    [0] = "South",
    [1] = "West",
    [2] = "North",
    [3] = "East",
    [4] = "Up",
    [5] = "Down",
    isUpOrDown = function(v)
        return v == 4 or v == 5
    end
}

Direction.Deltas = {
    [Direction.South] = { x = 0, y = 0, z = 1 },
    [Direction.West] = { x = - 1, y = 0, z = 0 },
    [Direction.North] = { x = 0, y = 0, z = - 1 },
    [Direction.East] = { x = 1, y = 0, z = 0 },
    [Direction.Up] = { x = 0, y = 1, z = 0 },
    [Direction.Down] = { x = 0, y = - 1, z = 0 },
    ["0,0,1"] = Direction.South,
    ["-1,0,0"] = Direction.West,
    ["0,0,-1"] = Direction.North,
    ["1,0,0"] = Direction.East,
    ["0,1,0"] = Direction.Up,
    ["0,-1,0"] = Direction.Down
}

if (Core == nil) then Core = { } end
Core.Direction = Direction
Core.Side = Side