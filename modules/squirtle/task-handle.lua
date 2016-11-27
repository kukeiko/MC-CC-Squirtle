local TaskHandle = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.TaskHandle"></returns>
function TaskHandle.new(task)
    local instance = { }
    setmetatable(instance, { __index = TaskHandle })
    instance:ctor(task)

    return instance
end

function TaskHandle:ctor(task)
    self._task = Squirtle.Task.as(task)
end

function TaskHandle:getTask()
    return self._task
end

--- <summary> instance: (Squirtle.TaskHandle) </summary>
--- <returns type="Squirtle.TaskHandle"></returns>
function TaskHandle.as(instance) return instance end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.TaskHandle = TaskHandle
