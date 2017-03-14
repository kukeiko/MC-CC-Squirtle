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
    self._taskQueue = Squirtle.TaskQueue.new()
    self._runningServices = { }

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
    else
        _G["log"] = function() end
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
        self._taskQueue:run()
    end , "task-queue")

    Core.MessagePump.create(nil, function()
        self._shell:run();
    end , "shell")

    Core.MessagePump.run( function()
        self._unit:load()
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

function Kernel:runApp(appType, charSpace)
    charSpace = charSpace or Kevlar.Terminal.new(term.current())

    local win = self._shell:openWindow(charSpace)

    Core.MessagePump.run( function()
        local app = appType.new(self, win)
        app:run()
    end )
end

function Kernel:queueTask(taskType, name, ...)
    local task = taskType.new(self, ...)
    self._taskQueue:queue(name, task)
end

function Kernel:startService(serviceType)
    local alreadyRunning = false

    for k, v in pairs(self._runningServices) do
        if (getmetatable(v) == serviceType) then
            alreadyRunning = true
            break
        end
    end

    if (not alreadyRunning) then
        local service = serviceType.new(self)
        service:start()

        table.insert(self._runningServices, service)
    end
end

function Kernel:stopService(serviceType)
    local index

    for k, v in pairs(self._runningServices) do
        if (getmetatable(v).__index == serviceType) then
            v:stop()
            index = k
            break
        end
    end

    if (index ~= nil) then
        table.remove(self._runningServices, index)
    end
end

function Kernel:getUnit()
    return self._unit
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Kernel = Kernel
