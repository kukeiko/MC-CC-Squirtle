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
    local menu = Kevlar.Menu.new( { wrapsAround = true })
    local subMenu = Kevlar.Menu.as(nil)

    for i = 1, 3 do
        subMenu = Kevlar.Menu.new()
        menu:addItem(subMenu)

        for e = 1, i do
            subMenu:addItem("item " .. i .. "." .. e, function() log("invoked item " .. i .. "." .. e) end)
        end
    end

    self._window:setContent(menu)
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TestApp = TestApp
Squirtle.Apps.TestApp = TestApp