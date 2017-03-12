local TaskHandle = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.TaskHandle"></returns>
function TaskHandle.new(name, task)
    local instance = { }
    setmetatable(instance, { __index = TaskHandle })
    instance:ctor(name, task)

    return instance
end

function TaskHandle:ctor(name, task)
    self._name = name
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
