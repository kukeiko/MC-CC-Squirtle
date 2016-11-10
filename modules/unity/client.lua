local Client = { }

function Client.broadcast(name, adapter, port)
    adapter = Unity.Adapter.cast(adapter)
    local packets = { }
    local token = adapter:newToken()

    adapter:send(name..":s", nil, token, nil, port, port)

    while(true) do
        -- todo: handle errors from server (first argument in packet data is success boolean)
        local packet = adapter:tryReceive(name..":r", token, nil, adapter:getAddress(), port, 1)
        if(packet == nil) then break end
        table.insert(packets, packet)
    end

    return packets
end

--- <summary></summary>
--- <returns type="Unity.Packet"></returns>
function Client.nearest(name, adapter, port)
    local packets = Client.broadcast(name, adapter, port)
    if (#packets == 0) then error("No response from broadcast @ port "..port) end

    local packet = Unity.Packet.cast(nil)
    local best, nearest

    -- todo: handle errors from server (first argument in packet data is success boolean)
    for i = 1, #packets do
        packet = packets[i]
        if (nearest == nil or nearest > packet:getDistance()) then
            nearest = packet:getDistance()
            best = packet
        end
    end

    return best
end

--- <summary></summary>
--- <returns type="Unity.Adapter"></returns>
function Client.new(adapter, serverAddress, port)
    local instance = { }
    setmetatable(instance, { __index = Client })
    instance:ctor(adapter, serverAddress, port)

    return instance
end

function Client:ctor(adapter, serverAddress, port)
    self._adapter = Unity.Adapter.cast(adapter)
    self._serverAddress = serverAddress
    self._port = port
end

function Client:send(name, ...)
    local token = self._adapter:newToken()
    local packet = self._adapter:sendAndReceive(name..":s", name..":r", { ...}, token, self._serverAddress, self._port, self._port, 1)
    local data = packet:getData()
    local success = table.remove(data, 1)

    if(not success) then
        error(data[1])
    else    
        return unpack(data)
    end
end

function Client:getAdapter()
    return self._adapter
end

function Client:changeAddress(newAddress)
    self._serverAddress = newAddress
end

local index = function(t, k)
    if (rawget(t, k)) then return rawget(t, k) end
    if (Client[k]) then return Client[k] end

    return function(self, ...)
        return Client.send(self, k, ...)
    end
end

local ClientProxy = { }
setmetatable(ClientProxy, { __index = index })

--- <summary></summary>
--- <returns type="Unity.ClientProxy"></returns>
function ClientProxy.new(adapter, serverAddress, port)
    local instance = Client.new(adapter, serverAddress, port)
    setmetatable(instance, { __index = ClientProxy })

    return instance
end

if (Unity == nil) then Unity = { } end
Unity.Client = Client
Unity.ClientProxy = ClientProxy