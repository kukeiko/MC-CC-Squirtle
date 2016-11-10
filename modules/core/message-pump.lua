--- Event Handling / Parallel execution API.
-- Similar to (and compatible with) the native parallel API, but provides additional functionality:<br />
--  - adding handlers (i.e. callbacks) / coroutines at runtime via @{create} and @{add}<br />
--  - subscribing handlers to incoming events using @{on}<br />
-- <br />
-- <u>Whats the difference between @{create}/@{add} and @{on}?</u><br />
-- Handlers / coroutines added via @{create}/@{add} behave like any other coroutine: they are executed / resumed as soon as
-- their awaited event is pulled.
-- <br />
-- <br />
-- Handlers registered via @{on} will execute as a separate coroutine <b>each</b> time their awaited event is pulled,
-- and are then handled as any normal coroutine.
-- <br />
-- <br />
-- <u>For example:</u><br />
-- 	You wait for a key event using os.pullEvent(), then execute a blocking turtle function (pretty much all of them),
--  the code will block until a turtle_response is received - any pulled key events inbetween are lost. Thats when
-- 	you want to use the @{on} function, e.g. MessagePump.on("key", function() turtle.turnLeft() end).
--
-- Don't forget to call off(<eventId returned by on()>) if you no longer need to listen to that event, or else
-- the MessagePump will run indefinitely.
-- @module MessagePump

local MessagePump = {
    _nextCoroutineId = 1,
    _coroutines = { },
    _numCoroutines = 0,
    _coroutineFilters = { },
    _eventListeners = { },
    _eliminate = { },
    _isRunning = false,
    _doQuit = false
}

--- <summary>
--- Adds the given handlers to the current coroutine pool and starts the MessagePump if it is not already running.
-- -
--- Any handlers added this way are executed the next time an event is pulled. To ensure execution, the MessagePump
--- will queue a MessagePump:Bootstrap dummy event that has no arguments.
-- -
--- The MessagePump will run until either all its registered coroutines finished or @{quit} was called.
--- </summary>
--- @param ... the handlers to run. Any handler followed by a string will use that string as its name.
--- @usage
--- -- the following code adds 3 handlers:
--- --     the first one is named "key printer" and prints any key pressed
--- --     the second one has no name and will only print the first key pressed, then die
--- --     the third one is named "quitter" and will terminate the MessagePump as soon as the F1 key is pressed
--- MessagePump.run( function()
---     while (true) do
---         local _, key = os.pullEvent("key")
---         print("pulled key ", key)
---     end
--- end , "key printer", function()
---     local event = os.pullEvent()
---     print("pulled any event and will finish: ", event)
--- end, function()
---     while (true) do
---         local _, key = os.pullEvent("key")
-- -
---         if (key == keys.f1) then
---             print("pulled f1, quitting message pump")
---             MessagePump.quit()
---         end
---     end
--- end , "quitter")
function MessagePump.run(...)
    local funcs = { ...}

    for i = 1, #funcs do
        if (type(funcs[i]) == "function") then
            local name = nil
            if (type(funcs[i + 1]) == "string") then name = funcs[i + 1] end
            MessagePump.create(nil, funcs[i], name)
        end
    end

    -- bootstraps given coroutines
    os.queueEvent("MessagePump:Bootstrap")

    if (MessagePump._isRunning) then return true end
    MessagePump._isRunning = true

    while (MessagePump._numCoroutines > 0 and not MessagePump._doQuit) do
        -- make a copy of current coroutines since original may change during coroutine execution
        local coroutines = table.copy(MessagePump._coroutines)
        MessagePump._eliminate = { }
        local eventData = { os.pullEventRaw() }
        local eventName = eventData[1]

        for coroId, coro in pairs(coroutines) do
            local filter = MessagePump._coroutineFilters[coroId]

            if (filter == nil or eventName == filter) then
                local success, param = coroutine.resume(coro, unpack(eventData))
                local status = coroutine.status(coro)

                if (not success) then
                    MessagePump.reset()
                    error(param, 0)
                end

                if (status == "dead") then
                    MessagePump._eliminate[coroId] = coro
                else
                    MessagePump._coroutineFilters[coroId] = param
                end
            end
        end

        for coroId, coro in pairs(MessagePump._eliminate) do
            MessagePump.removeCoroutine(coroId)
        end

        if (eventName == "terminate") then
            break
        end
    end

    MessagePump.reset()
end

--- <summary>
--- Removes all coroutines from the pool.
--- </summary>
function MessagePump.reset()
    MessagePump._nextCoroutineId = 1
    MessagePump._coroutines = { }
    MessagePump._numCoroutines = 0
    MessagePump._coroutineFilters = { }
    MessagePump._eventListeners = { }
    MessagePump._eliminate = { }
    MessagePump._isRunning = false
    MessagePump._doQuit = false
end

--- <summary>
--- Stops execution of the MessagePump.run() routine.
--- Coroutines listening to the current event pulled that have not yet been invoked are still executed.
--- </summary>
function MessagePump.quit()
    MessagePump._doQuit = true
end

--- <summary>
--- Adds a coroutine to the MessagePump.
--- </summary>
--- @param event the event name the coroutine initially waits for (nil for any)
--- @param coro the coroutine
--- @param name (optional) name of the coroutine
function MessagePump.add(event, coro, name)
    name = name or "Coroutine"
    local id = name .. ":" .. MessagePump._nextCoroutineId

    MessagePump._coroutines[id] = coro
    MessagePump._coroutineFilters[id] = event
    MessagePump._nextCoroutineId = MessagePump._nextCoroutineId + 1
    MessagePump._numCoroutines = MessagePump._numCoroutines + 1

    return id
end

--- <summary>
--- Wraps a handler in a coroutine and adds it to the MessagePump.
--- </summary>
--- @param event the event name the coroutine initially waits for (nil for any)
--- @param handler the handler to wrap into a coroutine
--- @param name (optional) name of the coroutine
function MessagePump.create(event, handler, name)
    return MessagePump.add(event, coroutine.create(handler), name)
end

--- <summary>
--- Creates an event handler.
-- -
--- Executes the handler as a separate coroutine each time the event occurs.</br>
--- Any handler added this way will remain indefinitely until @{off} is used to remove it.
--- </summary>
--- @param event the event name to listen to
--- @param handler the handler to execute
--- @param name (optional) name of the coroutine
--- @return internal id of the coroutine that can be used for @{off}
--- @usage
--- MessagePump.on("key", function(key, isBeingHeld)
---     if(key == keys.a) then
---         turtle.turnLeft()
---     elseif(key == keys.d) then
---         turtle.turnRight()
---     end
--- end)
-- -
--- MessagePump.run()
function MessagePump.on(event, handler, name)
    local couroutineId

    local helper = function(...)
        local args = { ...}
        table.remove(args, 1)

        while (MessagePump._eventListeners[couroutineId]) do
            local coro = coroutine.create(handler)
            local success, param = coroutine.resume(coro, unpack(args))

            if (coroutine.status(coro) == "suspended") then
                MessagePump.add(param, coro)
            end

            args = { coroutine.yield(event) }
            table.remove(args, 1)
        end
    end

    couroutineId = MessagePump.create(event, helper, name)
    MessagePump._eventListeners[couroutineId] = true

    return couroutineId
end

--- Removes an event handler.
--- @param couroutineId the id to the event handler (returned by @{on})
function MessagePump.off(couroutineId)
    if (MessagePump._eventListeners[couroutineId]) then
        MessagePump._eventListeners[couroutineId] = nil
        MessagePump._eliminate[couroutineId] = MessagePump._coroutines[couroutineId]
    end
end

--- <summary>
--- Determines if the MessagePump is running.
--- </summary>
--- @return boolean
function MessagePump.isRunning()
    return MessagePump._isRunning
end

--- <summary>
--- Pull the next event that matches the given name.
--- Almost alias of os.pullEvent(eventName): does not return the event name
--- </summary>
--- @param event the event to pull
--- @return ... parameters of the pulled event
function MessagePump.pull(event)
    local args = { os.pullEvent(event) }
    table.remove(args, 1)

    return unpack(args)
end

--- <summary>
--- Pull the next event that matches any of the given names.
--- </summary>
--- @param ... the events to pull
--- @return event, ... (parameters of the pulled event)
function MessagePump.pullMany(...)
    local requested = { ...}
    local eventNames = { }

    for i = 1, #requested do
        eventNames[requested[i]] = true
    end

    while (true) do
        local args = { os.pullEvent() }

        if (eventNames[args[1]] ~= nil) then
            return unpack(args)
        end
    end
end

function MessagePump.queue(...)
    os.queueEvent(...)
end

function MessagePump.remove(coroId)
    return MessagePump.removeCoroutine(coroId)
end

function MessagePump.removeCoroutine(coroId)
    MessagePump._coroutines[coroId] = nil
    MessagePump._coroutineFilters[coroId] = nil
    MessagePump._numCoroutines = MessagePump._numCoroutines - 1
end

if (Core == nil) then Core = { } end
Core.MessagePump = MessagePump
