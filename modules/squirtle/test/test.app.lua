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
    local vb = Kevlar.VerticalBranch.new()
    local header = Kevlar.Text.new("Test App", Kevlar.TextAlign.Center)
    local line = Kevlar.HLine.new("-")

    local menu = Kevlar.Menu.new()
    local itemvb = Kevlar.VerticalBranch.as(nil)

    for i = 1, 7 do
        local item = "item " .. i

        --        if (i % 2 == 0) then
        --            itemvb = Kevlar.VerticalBranch.new()
        --            local title = Kevlar.Text.new("Title " .. i, Kevlar.TextAlign.Center)
        --            local desc = Kevlar.Text.new("Description with words that are even longer now", Kevlar.TextAlign.Center)

        --            itemvb:addChild(title)
        --            itemvb:addChild(desc)

        --            item = itemvb
        --        end

        menu:addItem(item, function() log("item " .. i .. " invoked") end)
    end

    vb:addChild(header)
    vb:addChild(line)
    vb:addChild(menu)

    self._window:setContent(vb)
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.TestApp = TestApp
Squirtle.Apps.TestApp = TestApp