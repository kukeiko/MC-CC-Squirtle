local DigLineTask = { }

DigLineTask.Options = {
    orientation = nil
}

--- <summary>
--- </summary>
--- <returns type="Bulldoze.DigLineTask"></returns>
function DigLineTask.new(kernel, opts)
    local instance = { }
    setmetatable(instance, { __index = DigLineTask })
    instance:ctor(kernel, opts)

    return instance
end

function DigLineTask:ctor(kernel, opts)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._turtle = Squirtle.Turtle.as(self._kernel:getUnit())
    
    self._opts = self.asOptions(opts)
end

function DigLineTask:run()
    -- todo: dig sumthin!
end

--- <summary></summary>
--- <returns type="Bulldoze.DigLineTask"></returns>
function DigLineTask.as(instance) return instance end

--- <summary></summary>
--- <returns type="Bulldoze.DigLineTask.Options"></returns>
function DigLineTask.asOptions(instance)
    return instance
end

Bulldoze = Bulldoze or { }
Bulldoze.DigLineTask = DigLineTask

if (turtle) then
    Squirtle = Squirtle or { }
    Squirtle.Tasks = Squirtle.Tasks or { }
    Squirtle.Tasks.DigLineTask = DigLineTask
end
