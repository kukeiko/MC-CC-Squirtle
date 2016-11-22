local Kernel = { }

--- should boot unit, shell

--- <summary></summary>
--- <returns type="Squirtle.Kernel"></returns>
function Kernel.new()
    local instance = { }
    setmetatable(instance, { __index = Kernel })
    instance:ctor()

    return instance
end

function Kernel:ctor()
    self._shell = Squirtle.Shell.new(self)
    self._unit = Squirtle.Unit.as(nil)

    if (turtle) then
        self._unit = Squirtle.Turtle.new()
    elseif (pocket) then
        self._unit = Squirtle.Tablet.new()
    else
        self._unit = Squirtle.Computer.new()
    end
end

--- <summary></summary>
--- <returns type="Squirtle.Kernel"></returns>
function Kernel.as(instance) return instance end

function Kernel:run()
    --- todo: temporary
    if (peripheral.getType("front") == "monitor") then
        self._logOutput = peripheral.wrap("front")
        self._logY = 1
        self._logOutput.clear()
        _G["log"] = function(str) self:log(str) end
    end

    Core.MessagePump.on("key", function(ev)
        if (ev == keys.f5) then
            os.reboot()
        end
    end , "reboot-handler")

    Core.MessagePump.on("key", function(ev)
        if (ev == keys.f10) then
            Core.MessagePump.quit()
            Core.MessagePump.reset()
        end
    end , "kill-kernel-handler")

    Core.MessagePump.create(nil, function()
        --- todo: implement
    end , "task-queue")

    Core.MessagePump.create(nil, function()
        self._shell:run();
    end , "shell")

    Core.MessagePump.run( function()
        self:runApp(Squirtle.Apps.TurtleShell)
    end )
end

function Kernel:log(str)
    if (not self._logOutput) then return end
    local w, h = self._logOutput.getSize()

    if (self._logY > h) then
        self._logOutput.clear()
        self._logY = 1
    end

    self._logOutput.setCursorPos(1, self._logY)
    self._logOutput.write(str)

    self._logY = self._logY + 1
end

function Kernel:getAvailableApps()
    return Squirtle.Apps
end

function Kernel:runApp(app, charSpace)
    charSpace = charSpace or Kevlar.Terminal.new(term.current())

    local win = self._shell:openWindow(charSpace)

    Core.MessagePump.run( function()
        app = app.new(self, win)
        app:run()
    end )
end

function Kernel:runTask(task)
end

function Kernel:startService(service)
end

function Kernel:stopService(service)
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Kernel = Kernel 