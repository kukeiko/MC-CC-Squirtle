local Packet = {
    _nextId = 1
}

function Packet.new(name, data, token, destinationAddress, sourceAddress)
    local instance = { }
    setmetatable(instance, { __index = Packet })

    instance._id = "Packet:" .. os.getComputerID() .. ":" .. Packet._nextId
    instance._sourceAddress = sourceAddress
    instance._destinationAddress = destinationAddress
    instance._name = name
    instance._token = token
    instance._data = data
    instance._distance = 0
    instance._hops = { }

    Packet._nextId = Packet._nextId + 1

    return instance
end

--- <summary></summary>
--- <returns type="Unity.Packet"></returns>
function Packet.cast(instance) return instance end

function Packet:getId() return self._id end
function Packet:getName() return self._name end 
function Packet:getData() return self._data end
function Packet:getToken() return self._token end
function Packet:getSourceAddress() return self._sourceAddress end
function Packet:getDestinationAddress() return self._destinationAddress end
function Packet:getDistance() return self._distance end
function Packet:getHops() return self._hops end

function Packet:addDistance(distance)
    self._distance = self._distance + distance
end

function Packet:addHop(address)
    table.insert(self._hops, address)
end

if (Unity == nil) then Unity = { } end
Unity.Packet = Packet