local EventManager = { }

--- <summary>
--- </summary>
--- <returns type="Core.EventManager"></returns>
function EventManager.new()
    local instance = { }
    setmetatable(instance, { __index = EventManager })
    instance:ctor()

    return instance
end

function EventManager:ctor()
    self._handlers = { }
end

function EventManager:clear()
    self._handlers = { }
end

function EventManager:on(name, handler)
    if (self._handlers[name] == nil) then
        self._handlers[name] = { }
    end

    table.insert(self._handlers[name], handler)

    return handler
end

function EventManager:raise(name, ...)
    if (not self._handlers[name]) then return nil end

    for k, handler in ipairs(self._handlers[name]) do
        handler(...)
    end
end

function EventManager:off(name, handler)
    if (not self._handlers[name]) then return nil end

    local key

    for k, v in ipairs(self._handlers[name]) do
        if (v == handler) then
            key = k
            break
        end
    end

    if (key == nil) then return nil end

    table.remove(self._handlers[name], key)
end

if (Core == nil) then Core = { } end
Core.EventManager = EventManager
