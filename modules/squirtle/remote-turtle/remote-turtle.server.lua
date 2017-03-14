local RemoteTurtleServer = {
    port = 64,
    namespace = "RemoteTurtle"
}

--- <summary></summary>
--- <returns type="Squirtle.RemoteTurtle.RemoteTurtleServer"></returns>
function RemoteTurtleServer.new(kernel, service)
    local instance = { }
    setmetatable(instance, { __index = RemoteTurtleServer })

    instance:ctor(kernel, service)

    return instance
end

function RemoteTurtleServer:ctor(kernel, service)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._turtle = Squirtle.Turtle.as(self._kernel:getUnit())
    self._server = Unity.Server.as(nil)
    self._service = Squirtle.RemoteTurtle.RemoteTurtleService.as(service)
end

--- <summary></summary>
--- <returns type="Squirtle.RemoteTurtle.RemoteTurtleServer"></returns>
function RemoteTurtleServer.as(instance) return instance end

function RemoteTurtleServer:start()
    log("remote turtle server started")
    local adapter = self._turtle:getWirelessAdapter()
    self._server = Unity.Server.new(adapter, self.port, self.namespace)

    self._server:wrap(self, {
        "ping",false,
        "queueTask"
    } )
end

function RemoteTurtleServer:stop()
    self._server:close()
end

function RemoteTurtleServer:ping()
    log("received ping!")
    return "pong"
end

function RemoteTurtleServer:queueTask(typeName, name, ...)
    if (type(typeName) ~= "string") then error("expected type name to be a string") end
    if (#typeName == 0) then error("empty task type name") end

    local taskType = Squirtle.Tasks[typeName]
    if (not taskType) then error("no task named '" .. name .. "' found") end

    self._kernel:queueTask(taskType, name, ...)
end

if (turtle) then
    Squirtle = Squirtle or { }
    Squirtle.RemoteTurtle = Squirtle.RemoteTurtle or { }
    Squirtle.RemoteTurtle.RemoteTurtleServer = RemoteTurtleServer
end
