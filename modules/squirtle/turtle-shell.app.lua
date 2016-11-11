local TurtleShell = { }

function TurtleShell.new(unit, charSpace)
    local instance = { }
    setmetatable(instance, { __index = TurtleShell })

    instance:ctor(unit, charSpace)

    return instance
end

function TurtleShell:ctor(unit, charSpace)
    self._unit = Squirtle.Unit.as(unit)
    self._charSpace = Kevlar.ICharSpace.as(charSpace)
end

function TurtleShell:run()
    local header = Kevlar.Header.new("Shell", "-", self._charSpace:sub(1, 1, "*", 1))
    header:draw()

    local content = self._charSpace:sub(1, 3, "*", "*")
    self:loop(content)
end

function TurtleShell:loop(content)
    local apps = self._unit:getAvailableApps()
    local selection = Kevlar.Sync.Select.new(content)

    for k, v in pairs(apps) do
        selection:addOption(k, v)
    end

    local app = selection:run()
    print(app)

    local t = Squirtle.Turtle.as(self._unit)
    t:navigateTo(Core.Vector.new(208, 71, 191))
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TurtleShell = TurtleShell
Squirtle.Apps.TurtleShell = TurtleShell