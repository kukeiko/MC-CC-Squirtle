local BoolBox = { }

BoolBox.Format = {
    YesNo = 1,
    OnOff = 2,
    TrueFalse = 3
}

BoolBox.Options = {
    change = nil,
    format = nil,
    height = nil,
    hidden = nil,
    sizing = nil,
    value = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.BoolBox"></returns>
function BoolBox.new(opts)
    local instance = Kevlar.ProxyNode.new(Kevlar.SelectBox.new(opts))

    setmetatable(instance, { __index = BoolBox })
    setmetatable(BoolBox, { __index = Kevlar.ProxyNode })

    instance:ctor(opts)

    return instance
end

function BoolBox:ctor(opts)
    opts = self.asOptions(opts or { })
    opts.format = opts.format or BoolBox.Format.YesNo

    self._selectBox = Kevlar.SelectBox.as(self:base():getProxied())

    if (opts.format == self.Format.OnOff) then
        self._selectBox:addItem("On", true)
        self._selectBox:addItem("Off", false)
    elseif (opts.format == self.Format.TrueFalse) then
        self._selectBox:addItem("True", true)
        self._selectBox:addItem("False", false)
    else
        self._selectBox:addItem("Yes", true)
        self._selectBox:addItem("No", false)
    end

    self._selectBox:setValue(opts.value or false)
end

--- <summary></summary>
--- <returns type="Kevlar.BoolBox"></returns>
function BoolBox.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.BoolBox.Options"></returns>
function BoolBox.asOptions(instance)
    return instance
end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function BoolBox:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function BoolBox.super() return Kevlar.ProxyNode end

function BoolBox:getValue()
    return self._selectBox:getValue()
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.BoolBox = BoolBox
