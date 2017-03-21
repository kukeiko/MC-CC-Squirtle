local Form = { }

Form.Options = {
    height = nil,
    hidden = nil,
    submit = nil,
    sizing = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.Form"></returns>
function Form.new(opts)
    local proxied = Kevlar.VerticalBranch.new(opts)
    local instance = Kevlar.ProxyNode.new(proxied)

    setmetatable(instance, { __index = Form })
    setmetatable(Form, { __index = Kevlar.ProxyNode })

    instance:ctor(proxied, opts)

    return instance
end

function Form:ctor(proxied, opts)
    opts = self.asOptions(opts or { })

    self._vBranch = Kevlar.VerticalBranch.as(proxied)
    self._menu = Kevlar.Menu.new()
    self._controlMap = { }
    self._vBranch:addChild(self._menu)
    self._onOk = opts.submit or function() end
    --    self._actionMenu = Kevlar.Menu.new()
    --    self._vBranch:addChild(Kevlar.HLine.new(" "))
    --    self._vBranch:addChild(self._actionMenu)
end

--- <summary></summary>
--- <returns type="Kevlar.Form"></returns>
function Form.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Form.Options"></returns>
function Form.asOptions(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function Form:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function Form.super() return Kevlar.ProxyNode end

function Form:addControl(label, name, control)
    handler = handler or function() end

    local item = Kevlar.HorizontalBranch.new( {
        children =
        {
            Kevlar.Text.new( { text = label }),
            control
        }
    } )

    self._controlMap[name] = control
    self._menu:addItem(item, function() self._onOk(self:getValue()) end)
end

function Form:onSubmit(handler)
    self._onOk = handler
end

function Form:getValue()
    local value = { }

    for k, v in pairs(self._controlMap) do
        value[k] = v:getValue()
    end

    return value
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Form = Form
