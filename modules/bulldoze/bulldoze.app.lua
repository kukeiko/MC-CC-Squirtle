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
        local label = Kevlar.Text.new("Direction: ")
        local sb = Kevlar.SelectBox.new( {
            items =
            {
                Core.Direction.South,
                { text = Core.Direction[Core.Direction.West], value = Core.Direction.West },
                Core.Direction.North,
                Core.Direction.East,
            }
        } )

        local hb = Kevlar.HorizontalBranch.new( { children = { label, sb }, sizing = Kevlar.Sizing.Dynamic })
        menu:addItem(hb, function() end)
        --        log(sb)
        --        local dir = Core.Direction.South
        --        local label = Kevlar.Text.new("Direction: ")
        --        local direction = Kevlar.Text.new(Core.Direction[dir])

        --        direction:onEvent(Kevlar.Event.Type.Key, function(ev)
        --            local key = ev:getValue()

        --            if (key == keys.left) then
        --                dir =(dir - 1) % 4
        --            elseif (key == keys.right) then
        --                dir =(dir + 1) % 4
        --            end

        --            direction:setText(Core.Direction[dir])
        --        end )

        --        local hb = Kevlar.HorizontalBranch.new( { children = { label, direction }, sizing = Kevlar.Sizing.Dynamic })
        --        foo = hb
        --        menu:addItem(hb, function() end)
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
