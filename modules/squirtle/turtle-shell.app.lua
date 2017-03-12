local TurtleShell = { }

function TurtleShell.new(kernel, win)
    local instance = { }
    setmetatable(instance, { __index = TurtleShell })

    instance:ctor(kernel, win)

    return instance
end

function TurtleShell:ctor(kernel, win)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._window = Kevlar.Window.as(win)
end

function TurtleShell:run()
    local list = Kevlar.SearchableList.new()
    local apps = self._kernel:getAvailableApps()

    for name, app in spairs(apps) do
        list:addItem(name, function() self._kernel:runApp(app) end)
    end

    self._window:setContent(list)
    self._window:hideHeader()
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TurtleShell = TurtleShell
Squirtle.Apps.TurtleShell = TurtleShell