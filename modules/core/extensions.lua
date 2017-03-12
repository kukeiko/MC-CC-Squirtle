function string.split(self, separator)
    if (separator == nil or separator == "") then
        separator = "%s"
    end

    local t = { }; i = 1

    for str in string.gmatch(self, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end

    return t
end

function vector.equals(a, b)
    return a.x == b.x and a.y == b.y and a.z == b.z
end

function table.indexOf(self, item)
    for i = 1, #self do
        if (self[i] == item) then return i end
    end

    return -1
end

function table.removeItem(self, item)
    local index = table.indexOf(self, item)
    if (index < 0) then return index end
    table.remove(self, index)

    return index
end

function table.size(self)
    local size = 0

    for k, v in pairs(self) do
        size = size + 1
    end

    return size
end

function table.copy(self)
    local copy = { }

    for k, v in pairs(self) do
        copy[k] = v
    end

    return copy
end

function table.keys(self)
    local keys = { }

    for k, v in pairs(self) do
        table.insert(keys, k)
    end

    return keys
end

function table.key(self, item)
    for k, v in pairs(self) do
        if (item == v) then return k end
    end
end

function table.groupBy(self, name)
    local t = { }

    for k, v in pairs(self) do
        if (t[v[name]] == nil) then t[v[name]] = { } end

        table.insert(t[v[name]], v)
    end

    return t
end

function table.toArray(self)
    local t = { }

    for k, v in pairs(self) do
        table.insert(t, v)
    end

    return t
end

function table.concatTable(self, other)
    for i = 1, #other do
        self[#self + 1] = other[i]
    end

    return self
end

function table.select(self, nameOrFunc)
    local t = { }

    if (type(nameOrFunc) == "string") then
        for k, v in pairs(self) do
            table.insert(t, v[nameOrFunc])
        end
    elseif (type(nameOrFunc) == "function") then
        for k, v in pairs(self) do
            table.insert(t, nameOrFunc(v))
        end
    end

    return t
end

function table.reverse(self)
    local t = { }

    for i = #self, 1, -1 do
        t[#self - i + 1] = self[i]
    end

    return t
end