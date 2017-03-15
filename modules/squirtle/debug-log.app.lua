local DebugLogApp = { }

function DebugLogApp.new(kernel, win)
    local instance = { }
    setmetatable(instance, { __index = DebugLogApp })

    instance:ctor(kernel, win)

    return instance
end

function DebugLogApp:ctor(kernel, win)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._window = Kevlar.Window.as(win)
    self._window:setTitle("Debug Log")
end

function DebugLogApp:run()
    local list = Kevlar.PagedList.new()

    self._window:onBeforeUpdate( function()
        local lines = Core.Log.getEntries()
        list:clearItems()

        for i = 1, #lines do
            list:addItem(lines[i], function()
                local txt = Kevlar.Text.new( { text = lines[i] })
                self._window:setContent(txt)
            end )
        end
    end )

    self._window:setContent(list)
end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Apps == nil) then Squirtle.Apps = { } end

Squirtle.DebugLogApp = DebugLogApp
Squirtle.Apps.DebugLog = DebugLogApp