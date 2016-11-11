local Input = { }

--- <summary>
--- </summary>
--- <returns type="Kevlar.Sync.Input"></returns>
function Input.new(charSpace)
    local instance = { }
    setmetatable(instance, { __index = Input })
    instance:ctor(charSpace)

    return instance
end

function Input:ctor(charSpace)
    self._charSpace = Kevlar.ICharSpace.as(charSpace)
end

function Input:read()
    local value = ""

    while (true) do
        self._charSpace:clear()
        self._charSpace:write(1, 1, value)

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