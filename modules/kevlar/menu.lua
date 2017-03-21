local Menu = { }

Menu.Options = {
    height = nil,
    hidden = nil,
    wrapsAround = false,
    sizing = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.Menu"></returns>
function Menu.new(opts)
    local proxied = Kevlar.VerticalBranch.new(opts)
    local instance = Kevlar.ProxyNode.new(proxied)
    setmetatable(instance, { __index = Menu })
    setmetatable(Menu, { __index = Kevlar.ProxyNode })

    instance:ctor(proxied, opts)

    return instance
end

function Menu:ctor(proxied, opts)
    opts = self.asOptions(opts or { })

    self._vBranch = Kevlar.VerticalBranch.as(proxied)
    self._selectedIndex = 1
    self._wrapsAround = opts.wrapsAround or false

    self:base():onEvent(Kevlar.Event.Type.Key, function(ev)
        local key = ev:getValue()

        if (key == keys.up) then
            if (self._vBranch:base():focusPrevious(self._wrapsAround)) then
                ev:consume()
            end
        elseif (key == keys.down) then
            if (self._vBranch:base():focusNext(self._wrapsAround)) then
                ev:consume()
            end
        elseif (key == keys.enter) then
            local focused = self._vBranch:base():getFocusedChild()

            if (focused) then
                local handler = focused:getData("handler")

                if (handler) then
                    handler()
                    ev:consume()
                end
            end
        end
    end )
end

--- <summary></summary>
--- <returns type="Kevlar.Menu"></returns>
function Menu.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Menu.Options"></returns>
function Menu.asOptions(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function Menu:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.ProxyNode"></returns>
function Menu.super() return Kevlar.ProxyNode end

function Menu:update()
    local indicator = Kevlar.Text.as(nil)

    for i, child in ipairs(self._vBranch:base():getChildren()) do
        indicator = child:getChildByName("indicator")

        if (child:isFocused()) then
            indicator:setText("> ")
        else
            indicator:setText("  ")
        end
    end

    Menu.super().update(self)
end

function Menu:addItem(textOrNode, handler)
    handler = handler or function() end

    local node = Kevlar.Node.as(textOrNode)
    local makeIndicatorFocusable = false

    if (type(textOrNode) == "string") then
        node = Kevlar.Text.new( {
            isFocusable = true,
            text = textOrNode,
        } )
    elseif (not textOrNode:isFocusable()) then
        makeIndicatorFocusable = true
    end

    local container = Kevlar.HorizontalBranch.new( {
        data = { handler = handler },
        children =
        {
            {
                name = "indicator",
                node = Kevlar.Text.new( {
                    text = "  ",
                    align = Kevlar.TextAlign.Left,
                    width = 2,
                    height = 1,
                    sizing = Kevlar.Sizing.Fixed,
                    isFocusable = makeIndicatorFocusable
                } )
            },
            {
                name = "item",
                node = node
            }
        }
    } )

    self._vBranch:addChild(container)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Menu = Menu