if (not pocket) then return end

local RemoteTurtle = { }

function RemoteTurtle.new(kernel, win)
    local instance = { }
    setmetatable(instance, { __index = RemoteTurtle })

    instance:ctor(kernel, win)

    return instance
end

function RemoteTurtle:ctor(kernel, win)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._window = Kevlar.Window.as(win)
end

function RemoteTurtle:run()
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

Squirtle.RemoteTurtle = RemoteTurtle
Squirtle.Apps.RemoteTurtle = RemoteTurtle