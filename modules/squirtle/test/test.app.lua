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
    local menu = Kevlar.Menu.new( { wrapsAround = true, sizing = Kevlar.Sizing.Stretched })
    local subMenu = Kevlar.Menu.as(nil)

    for i = 1, 2 do
        subMenu = Kevlar.Menu.new()
        menu:addItem(subMenu)

        for e = 1, i + 1 do
            subMenu:addItem("item " .. i .. "." .. e, function()
                log(subMenu:getSizing())
            end )
        end

        if (i == 1) then
            subMenu:setSizing(Kevlar.Sizing.Stretched)
        end
    end

    --    local vb = Kevlar.VerticalBranch.new( {
    --        focusEnabled = true,
    --        children =
    --        {
    --            Kevlar.Textbox.new(),Kevlar.Textbox.new()
    --        }
    --    } )

    self._window:setContent(menu)
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TestApp = TestApp
Squirtle.Apps.TestApp = TestApp