local Item = { }

--- <summary>
--- id: (string)
--- quantity: (number)
--- damage: (number)
--- </summary>
--- <returns type="Core.Item"></returns>
function Item.new(id, quantity, damage)
    local instance = { }
    setmetatable(instance, { __index = Item })

    instance._id = id
    instance._quantity = quantity
    instance._damage = damage;

    return instance
end

--- <summary>
--- itemDetail: (table) item detail as returned from turtle.getItemDetail(slot)
--- </summary>
--- <returns type="Core.Item"></returns>
function Item.fromItemDetail(itemDetail)
    return Item.new(itemDetail.name, itemDetail.count, itemDetail.damage)
end

--- <summary>
--- item: (Item)
--- </summary>
--- <returns type="Core.Item"></returns>
function Item.as(item)
    return item
end

function Item:getId()
    return self._id
end

function Item:getQuantity()
    return self._quantity
end

function Item:getDamage()
    return self._damage
end

function Item:isChest()
    return string.match(self:getId():lower(), "chest") ~= nil
end

if (Core == nil) then Core = { } end
Core.Item = Item