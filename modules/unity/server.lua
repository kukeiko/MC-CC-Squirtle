local Server = { }

--- <summary></summary>
--- <returns type="Unity.Server"></returns>
function Server.new(adapter, port)
    local instance = { }
    setmetatable(instance, { __index = Server })
    instance:ctor(adapter, port)

    return instance
end

function Server:ctor(adapter, port)
    self._adapter = Unity.Adapter.cast(adapter)
    self._port = port
    self._em = EventManager.new()
    self._handlers = { }
end

function Server:listen(name, handler, onlyForMe)
    local adapter = self._adapter
    local address = adapter:getAddress()
    if (onlyForMe == false) then address = nil end

    local helper = function(packet)
        local result = { pcall( function() return handler(unpack(packet:getData())) end) }
        adapter:send(name .. ":r", result, packet:getToken(), packet:getSourceAddress(), self._port, self._port)
    end

    self._handlers[name] = adapter:onReceive(name .. ":s", nil, nil, address, self._port, helper)

--    if (onlyForMe == false) then
--        self._handlers[name .. ":all"] = adapter:onReceive(name .. ":s", nil, nil, adapter:getAddress(), self._port, helper)
--    end
end

function Server:close()
    for k, v in pairs(self._handlers) do
        self._adapter:off(v)
    end
end

function Server:wrap(instance, names)
    for i = 1, #names do
        if (type(names[i]) == "string") then
            local onlyForMe = false
            if (type(names[i + 1] == "boolean")) then onlyForMe = names[i + 1] end

            self:listen(names[i], function(...) return instance[names[i]](instance, ...) end, onlyForMe)
        end
    end
end

if (Unity == nil) then Unity = { } end
Unity.Server = Server