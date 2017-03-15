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
    local returnToOrigin = Kevlar.BoolBox.new( { value = true })
    local digLeft = Kevlar.BoolBox.new( { value = false })
    local digRight = Kevlar.BoolBox.new( { value = false })
    local digTopOrFront = Kevlar.BoolBox.new( { value = false })
    local digBottomOrBack = Kevlar.BoolBox.new( { value = false })

    form:addControl("Direction: ", "direction", direction)
    form:addControl("Length: ", "length", length)
    form:addControl("Dig left: ", "digLeft", digLeft)
    form:addControl("Dig right: ", "digRight", digRight)
    form:addControl("Dig top/front: ", "digTopOrFront", digTopOrFront)
    form:addControl("Dig bottom/back: ", "digBottomOrBack", digBottomOrBack)
    form:addControl("Return: ", "returnToOrigin", returnToOrigin)

    local taskOpts = Bulldoze.DigLineTask.asOptions( { })

    form:onSubmit( function(value)
        taskOpts = value
        local length = taskOpts.length or 1
        local taskName = length .. "x => " .. Core.Direction[taskOpts.direction]

        if (taskOpts.returnToOrigin) then
            taskName = taskName .. " (returns)"
        end

        if (turtle) then
            self._kernel:queueTask(Bulldoze.DigLineTask, taskName, taskOpts)
        elseif (pocket) then
            local tablet = Squirtle.Tablet.as(self._kernel:getUnit())
            local packet = Unity.Client.nearest("RemoteTurtle:ping", tablet:getWirelessAdapter(), 64)
            local client = Unity.Client.new(tablet:getWirelessAdapter(), packet:getSourceAddress(), 64)

            client:send("RemoteTurtle:queueTask", "Bulldoze.DigLine", "Remote-Task-Test", taskOpts)
        end
        self._window:setContent(previous)
    end )

    self._window:setContent(form)
end

Bulldoze = Bulldoze or { }
Bulldoze.BulldozeApp = BulldozeApp

if (turtle or pocket) then
    Squirtle = Squirtle or { }
    Squirtle.Apps = Squirtle.Apps or { }
    Squirtle.Apps.Bulldoze = BulldozeApp
end
