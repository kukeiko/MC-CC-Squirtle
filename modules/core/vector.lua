local Vector = { }

--- <summary></summary>
--- <returns type="Core.Vector"></returns>
function Vector.new(x, y, z)
    local instance = Vector.cast( {
        x = x or 0,
        y = y or 0,
        z = z or 0
    } )

    return instance
end

--- <summary>Sets necessary metatables.</summary>
--- <returns type="Core.Vector"></returns>
function Vector.cast(instance)
    return setmetatable(instance, {
        __index = Vector,
        __add = Vector.plus,
        __sub = Vector.minus,
        __mul = Vector.multiply,
        __div = Vector.divide,
        __unm = Vector.negate,
        __mod = Vector.modulo,
        __pow = Vector.power,
        __eq = Vector.equals,
        __tostring = Vector.toString,
        __concat = Vector.concat
    } )
end

--- <summary>Intellisense helper</summary>
--- <returns type="Core.Vector"></returns>
function Vector.as(instance)
    return instance
end

function Vector.plus(a, b)
    if (type(a) == "number") then
        return Vector.new(b.x + a, b.y + a, b.z + a)
    elseif (type(b) == "number") then
        return Vector.new(a.x + b, a.y + b, a.z + b)
    else
        return Vector.new(a.x + b.x, a.y + b.y, a.z + b.z)
    end
end

function Vector.minus(self, other)
    if (type(other) == "number") then
        return Vector.new(self.x - other, self.y - other, self.z - other)
    else
        return Vector.new(self.x - other.x, self.y - other.y, self.z - other.z)
    end
end

function Vector.multiply(a, b)
    if (type(a) == "number") then
        return Vector.new(b.x * a, b.y * a, b.z * a)
    elseif (type(b) == "number") then
        return Vector.new(a.x * b, a.y * b, a.z * b)
    else
        return Vector.new(a.x * b.x, a.y * b.y, a.z * b.z)
    end
end

function Vector.divide(a, b)
    if (type(a) == "number") then
        return Vector.new(b.x / a, b.y / a, b.z / a)
    elseif (type(b) == "number") then
        return Vector.new(a.x / b, a.y / b, a.z / b)
    else
        return Vector.new(a.x / b.x, a.y / b.y, a.z / b.z)
    end
end

function Vector.modulo(self, other)
    if (type(other) == "number") then
        return Vector.new(self.x % other, self.y % other, self.z % other)
    else
        return Vector.new(self.x % other.x, self.y % other.y, self.z % other.z)
    end
end

function Vector.power(a, b)
    if (type(a) == "number") then
        return Vector.new(b.x ^ a, b.y ^ a, b.z ^ a)
    elseif (type(b) == "number") then
        return Vector.new(a.x ^ b, a.y ^ b, a.z ^ b)
    else
        return Vector.new(a.x ^ b.x, a.y ^ b.y, a.z ^ b.z)
    end
end

function Vector:equals(other)
    return self.x == other.x and self.y == other.y and self.z == other.z
end

function Vector:unit()
    local len = self:length()
    return Vector.new(self.x / len, self.y / len, self.z / len)
end

function Vector:unitX()
    return Vector.new(self.x / math.abs(self.x), 0, 0)
end

function Vector:unitY()
    return Vector.new(0, self.y / math.abs(self.y), 0)
end

function Vector:unitZ()
    return Vector.new(0, 0, self.z / math.abs(self.z))
end

function Vector:dot(other)
    return self.x * other.x + self.y * other.y + self.z * other.z
end

function Vector:cross(other)
    return Vector.new(
    self.y * other.z - self.z * other.y,
    self.z * other.x - self.x * other.z,
    self.x * other.y - self.y * other.x
    )
end

function Vector:length()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector:normalize()
    return self:unit()
end

function Vector:distance(other)
    return(other - self):length()
end

function Vector:negate()
    return Vector.new(- self.x, - self - y, - self.z)
end

function Vector:toString()
    return self.x .. "," .. self.y .. "," .. self.z
end

function Vector:concat(other)
    return tostring(self) .. tostring(other)
end

if (Core == nil) then Core = { } end
Core.Vector = Vector