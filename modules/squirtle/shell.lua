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

    local win = Kevlar.Window.as(nil)
    local event = Kevlar.Event.as(nil)

    repeat
        win = windows[winIndex]
        win:update()
        t:clear()
        win:draw(t)

        local ev, value = Core.MessagePump.pullMany("key", "char")

        if (ev == "key") then
            event = Kevlar.Event.new(Kevlar.Event.Type.Key, value)
        elseif (ev == "char") then
            event = Kevlar.Event.new(Kevlar.Event.Type.Char, value)
        end

        if (event:getType() == Kevlar.Event.Type.Key) then
            if (event:getValue() == keys.tab) then
                event:consume()

                winIndex = winIndex + 1

                if (winIndex > #windows) then
                    winIndex = 1
                end
            end
        end

        if (not event:isConsumed()) then
            win:dispatchEvent(event)
        end
    until false
end

function Shell:createTestWindow(terminal, text)
    terminal = Kevlar.Terminal.as(terminal)

    local list = Kevlar.SearchableList.new()

    for i = 1, 21 do
        list:addItem("item " .. i, function() end)
    end

    return Kevlar.Window.new(text, list, terminal:getSize())
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Shell = Shell