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
end

function TestApp:run()
    local list = Kevlar.SearchableList.new()
    local apps = self._kernel:getAvailableApps()

    for name, app in pairs(apps) do
        list:addItem(name, function() self._kernel:runApp(app) end)
    end

    self._window:setContent(list)
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TestApp = TestApp
Squirtle.Apps.TestApp = TestApp