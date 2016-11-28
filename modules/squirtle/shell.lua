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
    self._windows = { }
    self._charSpaces = { }
    self._winIndex = 1
end

--- <summary></summary>
--- <returns type="Squirtle.Shell"></returns>
function Shell.as(instance) return instance end

function Shell:run()
    local win = Kevlar.Window.as(nil)
    local charSpace = Kevlar.CharSpace.as(nil)
    local event = Kevlar.Event.as(nil)

    repeat
        local ev, value = Core.MessagePump.pullMany("key", "char", "Squirtle.Shell:Redraw")

        if (ev == "key") then
            event = Kevlar.Event.new(Kevlar.Event.Type.Key, value)
        elseif (ev == "char") then
            event = Kevlar.Event.new(Kevlar.Event.Type.Char, value)
        else
            event = nil
        end

        if (event and event:getType() == Kevlar.Event.Type.Key) then
            if (event:getValue() == keys.tab) then
                event:consume()

                self._winIndex = self._winIndex + 1

                if (self._winIndex > #self._windows) then
                    self._winIndex = 1
                end
            end
        end

        win = self._windows[self._winIndex]
        charSpace = self._charSpaces[self._winIndex]

        if (win and charSpace) then
            if (event and not event:isConsumed()) then
                win:dispatchEvent(event)
            end

            win:update()
            charSpace:clear()
            win:draw(charSpace)
        end
    until false
end

function Shell:openWindow(charSpace)
    charSpace = Kevlar.CharSpace.as(charSpace)

    local w, h = charSpace:getSize()
    local win = Kevlar.Window.new(nil, { width = w, height = h })

    table.insert(self._windows, win)
    table.insert(self._charSpaces, charSpace)
    self._winIndex = #self._windows

    Core.MessagePump.queue("Squirtle.Shell:Redraw")

    return win
end

function Shell:closeWindow(win)
    --- todo: implement
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Shell = Shell