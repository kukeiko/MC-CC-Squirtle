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
    local menu = Kevlar.Menu.new()
    local itemvb = Kevlar.VerticalBranch.as(nil)

    for i = 1, 3 do
        local item = "item " .. i

        if (i % 2 == 0) then
            itemvb = Kevlar.VerticalBranch.new()
            local title = Kevlar.Text.new( { text = "Title " .. i, align = Kevlar.TextAlign.Center })
            local tb = Kevlar.Textbox.new( { value = "moo", width = 7 })

            itemvb:addChild(title)
            itemvb:addChild(tb)

            item = itemvb
        end

        menu:addItem(item, function() log("item " .. i .. " invoked") end)
    end

    self._window:setContent(menu)
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TestApp = TestApp
Squirtle.Apps.TestApp = TestApp