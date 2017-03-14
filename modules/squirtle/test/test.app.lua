local TestApp = { }

function TestApp.new(kernel, win)
    local instance = { }
    setmetatable(instance, { __index = TestApp })
    instance:ctor(kernel, win)

    return instance
end

function TestApp:ctor(kernel, win)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._window = Kevlar.Window.as(win)
    self._window:setTitle("Test App")
end

function TestApp:run()
    if (turtle) then
        self._kernel:startService(Squirtle.RemoteTurtle.RemoteTurtleService)
        self._kernel:stopService(Squirtle.RemoteTurtle.RemoteTurtleService)
    end

    if (pocket) then
        local tablet = Squirtle.Tablet.as(self._kernel:getUnit())
        local packet = Unity.Client.nearest("RemoteTurtle:ping", tablet:getWirelessAdapter(), 64)
        local client = Unity.Client.new(tablet:getWirelessAdapter(), packet:getSourceAddress(), 64)

        client:send("RemoteTurtle:queueTask", "Bulldoze.DigLine", "Remote-Task-Test", {
            direction = Core.Direction.West,
            length = 7,
            returnToOrigin = true
        } )
    end
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TestApp = TestApp
Squirtle.Apps.TestApp = TestApp