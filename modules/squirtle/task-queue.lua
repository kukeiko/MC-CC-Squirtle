local TaskQueue = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.TaskQueue"></returns>
function TaskQueue.new()
    local instance = { }
    setmetatable(instance, { __index = TaskQueue })
    instance:ctor()

    return instance
end

function TaskQueue:ctor()
    self._queued = { }
    self._current = Squirtle.TaskHandle.as(nil)
    self._currentCoroId = nil
end

function TaskQueue:run()
    repeat
        local args = { Core.MessagePump.pullMany("TaskQueue:queued", "TaskQueue:finished") }
        local ev = args[1]

        if (ev == "TaskQueue:queued") then
            self:_dequeue()
        elseif (ev == "TaskQueue:finished") then
            local success = args[2]
            -- todo: do something with the success

            self._current = nil
            self._currentCoroId = nil
            self:_dequeue()
        end
    until false
end

function TaskQueue:queue(task)
    local handle = Squirtle.TaskHandle.new(task)
    table.insert(self._queued, handle)

    Core.MessagePump.queue("TaskQueue:queued")
end

function TaskQueue:_dequeue()
    if (self._current ~= nil or #self._queued == 0) then return end

    self._current = table.remove(self._queued, 1)
    self._currentCoroId = Core.MessagePump.create("TaskQueue:runTask", function()
        local args = {
            pcall( function()
                self._current:getTask():run()
            end )
        }

        -- todo: what do with error

        local success = args[1]

        Core.MessagePump.queue("TaskQueue:finished", success)
    end , "Task")

    Core.MessagePump.queue("TaskQueue:runTask")
end

--- <summary> instance: (Squirtle.TaskQueue) </summary>
--- <returns type="Squirtle.TaskQueue"></returns>
function TaskQueue.as(instance) return instance end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.TaskQueue = TaskQueue
