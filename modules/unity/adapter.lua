--- Modem wrapper
--- @module Unity.Adapter

local Adapter = { }

--- <summary></summary>
--- <returns type="Unity.Adapter"></returns>
function Adapter.new(address, modem, side)
    local instance = { }
    setmetatable(instance, { __index = Adapter })
    instance:ctor(address, modem, side)

    return instance
end

--- <summary></summary>
--- <returns type="Unity.Adapter"></returns>
function Adapter.cast(instance) return instance end

function Adapter:ctor(address, modem, side)
    self._nextTokenId = 1
    self._address = address
    self._modem = modem
    self._modemSide = side
    self._onReceiveListenerId = nil
    self._onReceiveListeners = { }
    self._nextOnReceiveListenerId = 1
end

--- Returns if is wireless
function Adapter:isWireless()
    return self._modem.isWireless()
end

--- Returns the modem
function Adapter:getModem()
    return self._modem
end

--- Returns the modem side
function Adapter:getModemSide()
    return self._modemSide
end

--- Returns the address
function Adapter:getAddress()
    return self._address
end

--- Generates new token
function Adapter:newToken()
    local token = self:getAddress() .. ":" .. self:getModemSide() .. ":" .. self._nextTokenId

    self._nextTokenId = self._nextTokenId + 1

    return token
end


--- <summary>
--- Send and receive data
--- </summary>
function Adapter:sendAndReceive(sName, rName, data, token, dest, chan, reply, timeout)
    chan = chan or 0
    reply = reply or 0
    timeout = timeout or 1

    self:send(sName, data, token, dest, chan, reply)
    local packet = self:receive(rName, token, dest, self:getAddress(), reply, timeout)

    return packet
end

--- Send data
function Adapter:send(name, data, token, dest, chan, reply)
    token = token or self:newToken()
    chan = chan or 0
    reply = reply or 0

    if (data == nil) then
        data = { }
    end

    local packet = Unity.Packet.new(name, data, token, dest, self:getAddress())
    -- , chan, reply)
    self:getModem().transmit(chan, reply, textutils.serialize(packet))

    return packet
end

--- Receive data
function Adapter:receive(name, token, source, dest, channel, timeout)
    local packet = self:tryReceive(name, token, source, dest, channel, timeout)

    if (packet == nil) then error("Timed out") end
    return packet
end

function Adapter:tryReceive(name, token, source, dest, channel, timeout)
    local timer
    if (timeout ~= nil) then timer = os.startTimer(timeout) end
    channel = channel or 0

    if (not self:getModem().isOpen(channel)) then
        self:getModem().open(channel)
    end

    while (true) do
        local eventName, sideNameOrTimer, receivedChannel, replyChannel, message, distance = os.pullEvent()

        if (eventName == "modem_message"
            and receivedChannel == channel
            and sideNameOrTimer == string.lower(Core.Side[self:getModemSide()]))
        then
            if (type(message) == "string") then
                local packet = textutils.unserialize(message)
                setmetatable(packet, { __index = Unity.Packet })

                if ((packet:getName() == name or name == nil)
                    and(packet:getToken() == token or token == nil)
                    and(packet:getSourceAddress() == source or source == nil)
                    and(packet:getDestinationAddress() == dest or dest == nil)) then

--                    Log.debug("[Unity.Adapter] Accepted Packet:", packet:getName(), packet:getSourceAddress(), "=>", packet:getDestinationAddress())

                    packet:addHop(self:getAddress())
                    packet:addDistance(distance)

                    return packet
                end
            end
        elseif (timer ~= nil and eventName == "timer" and sideNameOrTimer == timer) then
            return nil
        end
    end
end

--- Execute callback on receive
function Adapter:onReceive(name, token, source, dest, channel, callback)
    channel = channel or 0

    if (not self:getModem().isOpen(channel)) then
        self:getModem().open(channel)
    end

    -- set up single callback for modem_message that'll iterate over listeners
    -- and fire them as necessary
    if (table.size(self._onReceiveListeners) == 0) then
        local helper = function(side, receivedChannel, replyChannel, message, distance)
            if (side == string.lower(Core.Side[self:getModemSide()]) and type(message) == "string") then
                local packet = textutils.unserialize(message)
                setmetatable(packet, { __index = Unity.Packet })

                if (self._onReceiveListeners[packet:getName()] ~= nil) then
                    local copy = table.copy(self._onReceiveListeners[packet:getName()])
 
                    for k, v in pairs(copy) do
                        if ((packet:getSourceAddress() == v.sourceAddress or v.sourceAddress == nil)
                            and(packet:getDestinationAddress() == v.destinationAddress or v.destinationAddress == nil)
                            and(packet:getToken() == v.token or v.token == nil)
                            and(receivedChannel == v.channel)) then

--                            Log.debug("[Unity.Adapter] Accepted Packet:", packet:getName(), packet:getSourceAddress(), "=>", packet:getDestinationAddress())

                            packet:addHop(self:getAddress())
                            packet:addDistance(distance)

                            v.callback(packet)
                        end
                    end
                end
            end
        end

        self._onReceiveListenerId = Core.MessagePump.on("modem_message", helper)
    end

    local onReceiveId = "OnReceive:" .. self._nextOnReceiveListenerId
    self._nextOnReceiveListenerId = self._nextOnReceiveListenerId + 1

    if (self._onReceiveListeners[name] == nil) then
        self._onReceiveListeners[name] = { }
    end

    self._onReceiveListeners[name][onReceiveId] = { name = name, sourceAddress = source, destinationAddress = dest, channel = channel, token = token, callback = callback }

    return onReceiveId
end

--- Remove receive callback
function Adapter:off(onReceiveId)
    local packetName = nil

    for k, v in pairs(self._onReceiveListeners) do
        if (v[onReceiveId] ~= nil) then
            packetName = k

            break
        end
    end

    if (packetName) then
        self._onReceiveListeners[packetName][onReceiveId] = nil

        if (table.size(self._onReceiveListeners[packetName]) == 0) then
            self._onReceiveListeners[packetName] = nil
        end
    end

    if (table.size(self._onReceiveListeners) == 0) then
        Core.MessagePump.off(self._onReceiveListenerId)
    end
end

if (Unity == nil) then Unity = { } end
Unity.Adapter = Adapter