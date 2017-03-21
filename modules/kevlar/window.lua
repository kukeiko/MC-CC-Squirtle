local Window = { }

local EventNames = {
    onBeforeUpdate = "Window:onBeforeUpdate"
}

--- <summary></summary>
--- <returns type="Kevlar.Window"></returns>
function Window.new(content, opts)
    local instance = Kevlar.Node.new(opts)
    setmetatable(instance, { __index = Window })
    setmetatable(Window, { __index = Kevlar.Node })

    instance:ctor(content)

    return instance
end

function Window:ctor(content)
    self._content = Kevlar.Node.as(nil)
    self._defaultContent = Kevlar.Node.as(nil)
    self._vBranch = Kevlar.VerticalBranch.new()

    self._header = Kevlar.Text.new( { text = "Window", align = Kevlar.TextAlign.Center })
    self._line = Kevlar.HLine.new("-")

    self._vBranch:addChild(self._header, "header")
    self._vBranch:addChild(self._line, "line")

    if (content ~= nil) then
        self:setContent(content)
    end
end

--- <summary></summary>
--- <returns type="Kevlar.Window"></returns>
function Window.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Window:base() return self end

function Window:update()
    self:base():getEventManager():raise(EventNames.onBeforeUpdate)

    local buffer = self:base():getBuffer()

    self._vBranch:setSize(buffer:getSize())
    self._vBranch:update()
    self._vBranch:draw(buffer)
end

function Window:getContent()
    return self._content
end

function Window:setContent(content)
    if (self._content == nil) then
        self._defaultContent = content
    elseif (self._isFocused) then
        self._content:blur()
    end

    self._content = content
    self._vBranch:removeChildByName("content")

    if (content ~= nil) then
        self._content:setSizing(Kevlar.Sizing.Stretched)
        self._vBranch:addChild(content, "content")

        if (self._isFocused) then
            self._content:focus()
        end
    end
end

function Window:setTitle(title)
    self._header:setText(title)
end

function Window:showHeader()
    self._header:show()
    self._line:show()
end

function Window:hideHeader()
    self._header:hide()
    self._line:hide()
end

function Window:onBeforeUpdate(handler)
    self:base():getEventManager():on(EventNames.onBeforeUpdate, handler)
end

function Window:dispatchEvent(event)
    if (self._content == nil) then return end
    event = Kevlar.Event.as(event)

    if (event:getType() == Kevlar.Event.Type.Key and event:getValue() == keys.f1) then
        if (self._defaultContent ~= nil) then
            self:setContent(self._defaultContent)
            event:consume()
            return
        end
    end

    self._content:dispatchEvent(event)
end

function Window:focus()
    self._isFocused = true

    if (self._content) then
        self._content:focus()
    end

    return true
end

function Window:isFocused()
    return self._isFocused
end

function Window:isFocusable()
    return true
end

function Window:blur()
    self._isFocused = false

    if (self._content) then
        self._content:blur()
    end
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Window = Window