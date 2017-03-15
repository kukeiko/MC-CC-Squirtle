local TestTask = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.TestTask"></returns>
function TestTask.new(kernel)
    local instance = Squirtle.Task.new()
    setmetatable(instance, { __index = TestTask })
    setmetatable(TestTask, { __index = Squirtle.Task })
    instance:ctor(kernel)

    return instance

end

function TestTask:ctor(kernel)
    self._kernel = Squirtle.Kernel.as(kernel)
    self._turtle = Squirtle.Turtle.as(self._kernel:getUnit())
end

function TestTask:run()
    self._turtle:turn(Core.Side.Left)
end

--- <summary> instance: (Squirtle.TestTask) </summary>
--- <returns type="Squirtle.TestTask"></returns>
function TestTask.as(instance) return instance end

if (Squirtle == nil) then Squirtle = { } end
if (Squirtle.Tasks == nil) then Squirtle.Tasks = { } end

Squirtle.TestTask = TestTask
Squirtle.Tasks.TestTask = TestTask