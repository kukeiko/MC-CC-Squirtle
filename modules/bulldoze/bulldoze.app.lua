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

    menu:addItem("Dig Line", function() self:digLine() end)

    self._window:setContent(menu)
end

function BulldozeApp:digLine()
    local menu = Kevlar.Menu.new()
    local foo

    for i = 1, 7 do
        local label = Kevlar.Text.new( { text = "Direction: " })
        local sb = Kevlar.SelectBox.new( {
            align = Kevlar.TextAlign.Center,
            sizing = Kevlar.Sizing.Stretched,
            items =
            {
                { text = Core.Direction[Core.Direction.South], value = Core.Direction.South, handler = function() log("south!") end },
                { text = Core.Direction[Core.Direction.West], value = Core.Direction.West, handler = function() log("west!") end },
                { text = Core.Direction[Core.Direction.North], value = Core.Direction.North, handler = function() log("north!") end },
                { text = Core.Direction[Core.Direction.East], value = Core.Direction.East, handler = function() log("east!") end },
            }
        } )

        local hb = Kevlar.HorizontalBranch.new( { children = { label, sb }, sizing = Kevlar.Sizing.Dynamic })
        menu:addItem(hb, function() end)
    end

    self._window:setContent(menu)
end

Bulldoze = Bulldoze or { }
Bulldoze.BulldozeApp = BulldozeApp

if (turtle) then
    Squirtle = Squirtle or { }
    Squirtle.Apps = Squirtle.Apps or { }
    Squirtle.Apps.Bulldoze = BulldozeApp
end
