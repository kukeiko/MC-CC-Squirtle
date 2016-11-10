local Input = { }

--- <summary>
--- </summary>
--- <returns type="Kevlar.Sync.Input"></returns>
function Input.new(buffer)
    local instance = { }
    setmetatable(instance, { __index = Input })
    instance:ctor(buffer)

    return instance
end

function Input:ctor(buffer)
    self._buffer = Kevlar.IBuffer.as(buffer)
    self._buffer:clear("*")
end

function Input:read()
    local value = ""

    while (true) do
        self._buffer:clear()
        self._buffer:write(1, 1, value)
        local event, key = Core.MessagePump.pullMany("key", "char")

        if (event == "key") then
            if (key == keys.backspace) then
                local len = #value

                if (len ~= 0) then
                    value = value:sub(1, len - 1)
                end
            elseif (key == keys.enter) then
                return value
            elseif (key == Kevlar.escape) then
                return nil
            end
        elseif (event == "char") then
            value = value .. key
        end
    end
end

--- <summary>instance: (Kevlar.Input)</summary>
--- <returns type="Kevlar.Sync.Input"></returns>
function Input.cast(instance)
    return instance
end

if (Kevlar == nil) then Kevlar = { } end
if (Kevlar.Sync == nil) then Kevlar.Sync = { } end
Kevlar.Sync.Input = Input