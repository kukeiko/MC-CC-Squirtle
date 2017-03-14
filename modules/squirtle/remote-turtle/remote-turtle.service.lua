local RemoteTurtleService = { }

--- <summary></summary>
--- <returns type="Squirtle.RemoteTurtle.RemoteTurtleService"></returns>
function RemoteTurtleService.new(kernel)
    local instance = { }
    setmetatable(instance, { __index = RemoteTurtleService })

    instance:ctor(kernel)

    return instance
end

function RemoteTurtleService:ctor(kernel)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._turtle = Squirtle.Turtle.as(self._kernel:getUnit())
    self._server = Squirtle.RemoteTurtle.RemoteTurtleServer.new(self._kernel, self)
end

--- <summary></summary>
--- <returns type="Squirtle.RemoteTurtle.RemoteTurtleService"></returns>
function RemoteTurtleService.as(instance) return instance end

function RemoteTurtleService:start()
    self._server:start()
end

function RemoteTurtleService:stop()

end

if (turtle) then
    Squirtle = Squirtle or { }
    Squirtle.RemoteTurtle = Squirtle.RemoteTurtle or { }
    Squirtle.RemoteTurtle.RemoteTurtleService = RemoteTurtleService
    Squirtle.Services = Squirtle.Services or { }
    Squirtle.Services.RemoteTurtle = RemoteTurtleService
end
