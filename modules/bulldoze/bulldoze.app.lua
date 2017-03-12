local BulldozeApp = { }

function BulldozeApp.new(kernel, win)
    local instance = { }
    setmetatable(instance, { __index = BulldozeApp })

    instance:ctor(kernel, win)

    return instance
end

function BulldozeApp:ctor(kernel, win)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._window = Kevlar.Window.as(win)
    self._window:setTitle("Bulldoze")
end

function BulldozeApp:run()
    local menu = Kevlar.Menu.new()

    menu:addItem("Dig Line", function() self:digLine(menu) end)

    self._window:setContent(menu)
end

function BulldozeApp:digLine(previous)
    local form = Kevlar.Form.new()

    local direction = Kevlar.DirectionBox.new( { format = Kevlar.DirectionBox.Format.All })
    local length = Kevlar.NumberBox.new( { min = 1, max = 100 })
    local comeBack = Kevlar.BoolBox.new( { format = Kevlar.BoolBox.Format.TrueFalse })

    form:addControl("Direction: ", "direction", direction)
    form:addControl("Length: ", "length", length)
    form:addControl("Return: ", "comeBack", comeBack)

    form:onSubmit( function(value)
        local length = value.length or 1
        local taskName = length .. "x => " .. Core.Direction[value.direction]

        if (value.comeBack) then
            taskName = taskName .. " (returns)"
        end

        self._kernel:queueTask(Bulldoze.DigLineTask, taskName, {
            direction = value.direction,
            length = length,
            returnToOrigin = value.comeBack
        } )

        self._kernel:queueTask(Bulldoze.DigLineTask, taskName, {
            direction = value.direction,
            length = length,
            returnToOrigin = value.comeBack
        } )

        self._window:setContent(previous)
    end )

    self._window:setContent(form)
end

Bulldoze = Bulldoze or { }
Bulldoze.BulldozeApp = BulldozeApp

if (turtle) then
    Squirtle = Squirtle or { }
    Squirtle.Apps = Squirtle.Apps or { }
    Squirtle.Apps.Bulldoze = BulldozeApp
end
