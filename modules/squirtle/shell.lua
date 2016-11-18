local Shell = { }

--- should host windows

--- <summary></summary>
--- <returns type="Squirtle.Shell"></returns>
function Shell.new(kernel)
    local instance = { }
    setmetatable(instance, { __index = Shell })
    instance:ctor(kernel)

    return instance
end

function Shell:ctor(kernel)
    self._kernel = Squirtle.Kernel.as(kernel)
end

--- <summary></summary>
--- <returns type="Squirtle.Shell"></returns>
function Shell.as(instance) return instance end

function Shell:run()
    --    local mtr = peripheral.wrap("front")
    --    term.redirect(mtr)
    local t = Kevlar.Terminal.new(term.current())

    local winIndex = 1
    local windows = { }
    table.insert(windows, self:createTestWindow(t, "Khaz"))
    table.insert(windows, self:createTestWindow(t, "Mo"))
    table.insert(windows, self:createTestWindow(t, "Dan"))
    table.insert(windows, self:createTestWindow(t, "Foo"))
    table.insert(windows, self:createTestWindow(t, "Bar"))
    table.insert(windows, self:createTestWindow(t, "Baz"))

    local x = 0
    local y = 0

    repeat
        local win = windows[winIndex]
        win:update()
        win:draw(t, x, y)

        local key = Core.MessagePump.pull("key")

        if (key == keys.tab) then
            winIndex = winIndex + 1
            if (winIndex > #windows) then
                winIndex = 1
            end
        end

        if (key == keys.a) then
            x = x - 1
        elseif (key == keys.d) then
            x = x + 1
        elseif (key == keys.w) then
            y = y - 1
        elseif (key == keys.s) then
            y = y + 1
        end
    until false
end

function Shell:createTestWindow(terminal, text)
    terminal = Kevlar.Terminal.as(terminal)

    local vb = Kevlar.VerticalBranch.new()
    local hb = Kevlar.HorizontalBranch.new()
    hb:setSizing(Kevlar.Sizing.Stretched)
    vb:addChild(hb)

    local khazText = Kevlar.Text.new(text, Kevlar.Text.Align.Center)
    khazText:setSizing(Kevlar.Sizing.Stretched)
    hb:addChild(khazText)


    local moText = Kevlar.Text.new(text, Kevlar.Text.Align.Center)
    moText:setSizing(Kevlar.Sizing.Stretched)
    hb:addChild(moText)

    local quakText = Kevlar.Text.new(text)
    quakText:setSizing(Kevlar.Sizing.Stretched)
    vb:addChild(quakText)

    return Kevlar.Window.new(text, vb, terminal:getSize())
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Shell = Shell