local DirectionBox = { }

DirectionBox.Format = {
    All = 1,
    Cardinal = 2,
    UpAndDown = 3
}

DirectionBox.Options = {
    change = nil,
    format = nil,
    height = nil,
    hidden = nil,
    sizing = nil,
    value = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.DirectionBox"></returns>
function DirectionBox.new(opts)
    local instance = Kevlar.ProxyNode.new(Kevlar.SelectBox.new(opts))

    setmetatable(instance, { __index = DirectionBox })
    setmetatable(DirectionBox, { __index = Kevlar.ProxyNode })

    instance:ctor(opts)

    return instance
end

function DirectionBox:ctor(opts)
    opts = self.asOptions(opts or { })

    self._selectBox = Kevlar.SelectBox.as(self:base():getProxied())

    local format = opts.format or DirectionBox.Format.All

    if (format == DirectionBox.Format.All or format == DirectionBox.Format.Cardinal) then
        self._selectBox:addItem(Core.Direction[Core.Direction.North], Core.Direction.North)
        self._selectBox:addItem(Core.Direction[Core.Direction.East], Core.Direction.East)
        self._selectBox:addItem(Core.Direction[Core.Direction.South], Core.Direction.South)
        self._selectBox:addItem(Core.Direction[Core.Direction.West], Core.Direction.West)

        self._selectBox:setValue(opts.value or Core.Direction.North)
    end

    if (format == DirectionBox.Format.All or format == DirectionBox.Format.UpAndDown) then
        self._selectBox:addItem(Core.Direction[Core.Direction.Up], Core.Direction.Up)
        self._selectBox:addItem(Core.Direction[Core.Direction.Down], Core.Direction.Down)

        if (format == DirectionBox.Format.UpAndDown) then
            self._selectBox:setValue(opts.value or Core.Direction.Up)
        end
    end
end

--- <summary></summary>
--- <returns type="Kevlar.DirectionBox"></returns>
function DirectionBox.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.DirectionBox.Options"></returns>
function DirectionBox.asOptions(instance)
    return instance
end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function DirectionBox:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function DirectionBox.super() return Kevlar.ProxyNode end

function DirectionBox:getValue()
    return self._selectBox:getValue()
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.DirectionBox = DirectionBox
