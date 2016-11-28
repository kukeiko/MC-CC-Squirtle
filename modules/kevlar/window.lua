local Window = { }

--- <summary></summary>
--- <returns type="Kevlar.Window"></returns>
function Window.new(content, w, h)
    local instance = Kevlar.Node.new(w, h)
    setmetatable(instance, { __index = Window })
    setmetatable(Window, { __index = Kevlar.Node })

    instance:ctor(content)

    return instance
end

function Window:ctor(content)
    self._content = Kevlar.Node.as(nil)
    self._vBranch = Kevlar.VerticalBranch.new()

    self._header = Kevlar.Text.new("Window", Kevlar.TextAlign.Center)
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
    local buffer = self:base():getBuffer()

    self._vBranch:setSize(buffer:getSize())
    self._vBranch:update()
    self._vBranch:draw(buffer)
end

function Window:getContent()
    return self._content
end

function Window:setContent(content)
    self._content = content
    self._vBranch:removeChildByName("content")

    if (content ~= nil) then
        self._content:setSizing(Kevlar.Sizing.Stretched)
        self._vBranch:addChild(content, "content")
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

function Window:dispatchEvent(event)
    if (self._content == nil) then return end

    self._content:dispatchEvent(event)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Window = Window