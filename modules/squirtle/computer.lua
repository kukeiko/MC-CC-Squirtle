local Computer = { }

--- <summary>
--- </summary>
--- <returns type="Squirtle.Computer"></returns>
function Computer.new()
    local instance = Squirtle.Unit.new()

    setmetatable(Computer, { __index = Squirtle.Unit })
    setmetatable(instance, { __index = Computer })

    return instance
end

--- <summary>
--- Helper for BabeLua autocomplete
--- </summary>
--- <returns type="Squirtle.Unit"></returns>
function Computer:base() return self end

function Computer:load()
    Squirtle.Unit.load(self)
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Computer = Computer