local Unit = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.Unit"></returns>
function Unit.new()
    local instance = { }
    setmetatable(instance, { __index = Unit })
    instance:ctor()

    return instance
end

function Unit:ctor()
--    self._availableApps = { }
--    self._availableServices = { }
    self._runningServices = { }

--    local helper = function(owner, collection, path)
--        if (not Disk.exists(path)) then return end
--        for k, f in ipairs(Disk.getFiles(path)) do
--            local name = string.gsub(f, path, "")
--            name = string.gsub(name, "%.lua", "")
--            collection[name] = Utils.crawl(owner, name:split("."))
--        end
--    end

--    helper(Apps, self._availableApps, "/rom/apps/")
--    helper(Components, self._availableComponents, "/rom/components/")
--    helper(Services, self._availableServices, "/rom/services/")

--    if (self:isComputer()) then
--        helper(Apps, self._availableApps, "/rom/apps/computer/")
--        helper(Components, self._availableComponents, "/rom/components/computer/")
--        helper(Services, self._availableServices, "/rom/services/computer/")
--    elseif (self:isPocket()) then
--        helper(Apps, self._availableApps, "/rom/apps/pocket/")
--        helper(Components, self._availableComponents, "/rom/components/pocket/")
--        helper(Services, self._availableServices, "/rom/services/pocket/")
--    elseif (self:isTurtle()) then
--        helper(Apps, self._availableApps, "/rom/apps/turtle/")
--        helper(Components, self._availableComponents, "/rom/components/turtle/")
--        helper(Services, self._availableServices, "/rom/services/turtle/")
--    end
end

--- <summary> instance: (Squirtle.Unit) </summary>
--- <returns type="Squirtle.Unit"></returns>
function Unit.as(instance) return instance end

function Unit:load() end

function Unit:getDeviceId()
    return os.getComputerID()
end

function Unit:isComputer()
    return not self:isTurtle() and not self:isPocket()
end

function Unit:isTurtle()
    return turtle ~= nil
end

function Unit:isPocket()
    return pocket ~= nil
end

function Unit:getAvailableApps()
    return table.copy(Squirtle.Apps)
end

function Unit:startService(name)
    local available = self:getAvailableServices()
    if (available[name] == nil) then
        error("Service " .. name .. " doesn't exist")
    end

    local instance = available[name].new(self)
    self._runningServices[name] = instance
    instance:run()
end

function Unit:stopService(name)
    local instance = self._runningServices[name]

    if (instance == nil) then
        error("Service " .. name .. " is not running")
    end

    instance:stop()
    self._runningServices[name] = nil
end

function Unit:configService(name, charSpace)
    local instance = self._runningServices[name]

    if (instance == nil) then
        error("Service " .. name .. " is not running")
    end

    instance:config(charSpace)
end

function Unit:getAvailableServices()
    return table.copy(Squirtle.Services)
--    return self._availableServices
end

function Unit:getRunningServices()
    return self._runningServices
end

function Unit:getSleepingServices()
    local sleeping = { }
    local running = self:getRunningServices()

    for k, v in pairs(self:getAvailableServices()) do
        if (running[k] == nil) then
            sleeping[k] = v
        end
    end

    return sleeping
end

function Unit:numSleepingServices()
    return table.size(self:getSleepingServices())
end

function Unit:numRunningServices()
    return table.size(self:getRunningServices())
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Unit = Unit