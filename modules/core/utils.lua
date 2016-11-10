local Utils = {
    keyMap =
    {
        minus = "-",
        comma = ",",
        period = ".",
        space = " "
    }
}

function Utils.crawl(owner, fragments)
    for k, v in ipairs(fragments) do
        owner = owner[v]

        if (owner == nil) then
            error(table.concat(fragments, ".") .. " doesn't exist")
        end
    end

    return owner
end

function Utils.keyToChar(key)
    local name = keys.getName(key)

    if (name == nil) then
        return nil
    elseif (name:match("^%a$")) then
        return name
    elseif (key == 11) then
        return "0"
    elseif (key >= 2 and key <= 10) then
        return key - 1
    elseif (Utils.keyMap[name] ~= nil) then
        return Utils.keyMap[name]
    end
end

if (Core == nil) then Core = { } end
Core.Utils = Utils
