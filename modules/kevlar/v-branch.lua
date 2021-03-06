local VerticalBranch = { }

--- <summary></summary>
--- <returns type="Kevlar.VerticalBranch"></returns>
function VerticalBranch.new(opts)
    local instance = Kevlar.Branch.new(opts)
    setmetatable(instance, { __index = VerticalBranch })
    setmetatable(VerticalBranch, { __index = Kevlar.Branch })
    instance:ctor()

    return instance
end

function VerticalBranch:ctor()
end

--- <summary></summary>
--- <returns type="Kevlar.VerticalBranch"></returns>
function VerticalBranch.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function VerticalBranch.super() return Kevlar.Branch end

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function VerticalBranch:base() return self end

function VerticalBranch:update()
    local children = self:getVisibleChildren()
    local child = Kevlar.Node.as(nil)
    local buffer = self:base():base():getBuffer()
    local wMax, hMax = buffer:getSize()

    local hUsed = 0
    local stretched = { }
    local eligible = { }
    local minHeights = { }

    buffer:clear()

    for i, child in ipairs(children) do
        local minHeight
        local sizingMode = child:getSizing()

        if (sizingMode == Kevlar.Sizing.Fixed) then
            minHeight = child:getHeight()
        else
            minHeight = child:computeHeight(wMax)

            if (sizingMode == Kevlar.Sizing.Stretched) then
                table.insert(stretched, i)
            end
        end

        hUsed = hUsed + math.max(minHeight, 1)

        table.insert(eligible, child)
        table.insert(minHeights, minHeight)

        if (hUsed >= hMax) then
            break
        end
    end

    --- allocate extra space for stretched
    if (hUsed < hMax and #stretched > 0) then
        local remaining = hMax - hUsed
        local hEach = math.floor(remaining / #stretched)
        remaining = remaining -(hEach * #stretched)

        for i, v in ipairs(stretched) do
            if (i <= remaining) then
                minHeights[v] = minHeights[v] + hEach + 1
            else
                minHeights[v] = minHeights[v] + hEach
            end
        end
    end

    --- todo: possible overflow into y direction during processing of last child
    --- todo: overflow can be used  for scrolling
    local yOffset = 0
    for i, child in ipairs(eligible) do
        local minHeight = minHeights[i]
        local w = wMax

        if (child:getSizing() == Kevlar.Sizing.Fixed) then
            w = child:getWidth()
        end

        child:setSize(w, minHeight)
        child:update()
        child:draw(buffer:base():sub(1, yOffset + 1, "*", minHeight))

        yOffset = yOffset + minHeight
    end
end

--- <returns type="number"></returns>
function VerticalBranch:computeHeight(w)
    local child = Kevlar.Node.as(nil)
    local h = 0

    for i, child in ipairs(self:getVisibleChildren()) do
        if (child:getSizing() == Kevlar.Sizing.Fixed) then
            h = h + child:getHeight()
        else
            h = h + child:computeHeight(w)
        end
    end

    return h
end

function VerticalBranch:computeWidth(h)
    local child = Kevlar.Node.as(nil)
    local highest = 0

    for i, child in ipairs(self:getVisibleChildren()) do
        local w

        if (child:getSizing() == Kevlar.Sizing.Fixed) then
            w = child:getWidth()
        else
            w = child:computeWidth(h)
        end

        highest = math.max(highest, w)
    end

    return highest
end

function VerticalBranch:addChild(node, name)
    self.super().addChild(self, node, name)
end

function VerticalBranch:getChildren()
    return self.super().getChildren(self)
end

function VerticalBranch:removeChildren()
    return self.super().removeChildren(self)
end

function VerticalBranch:setAlign(align)
    self.super().setAlign(self, align)
end

function VerticalBranch:getAlign()
    return self.super().getAlign(self)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.VerticalBranch = VerticalBranch
