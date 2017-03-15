local Task = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.Task"></returns>
function Task.new()
    local instance = { }
    setmetatable(instance, { __index = Task })
    instance:ctor()

    return instance
end

function Task:ctor() end

function Task:run() end

--- <summary> instance: (Squirtle.Task) </summary>
--- <returns type="Squirtle.Task"></returns>
function Task.as(instance) return instance end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Task = Task
