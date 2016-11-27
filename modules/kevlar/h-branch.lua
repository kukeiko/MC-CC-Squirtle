local HorizontalBranch = { }

--- <summary></summary>
--- <returns type="Kevlar.HorizontalBranch"></returns>
function HorizontalBranch.new(w, h)
    local instance = Kevlar.Branch.new(w, h)
    setmetatable(instance, { __index = HorizontalBranch })
    setmetatable(HorizontalBranch, { __index = Kevlar.Branch })
    instance:ctor()

    return instance
end

function HorizontalBranch:ctor()
end

--- <summary></summary>
--- <returns type="Kevlar.HorizontalBranch"></returns>
function HorizontalBranch.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function HorizontalBranch.super() return Kevlar.Branch end

--- <summary></summary>
--- <returns type="Kevlar.Branch"></returns>
function HorizontalBranch:base() return self end

function HorizontalBranch:update()
    local child = Kevlar.Node.as(nil)
    local buffer = self:base():base():getBuffer()
    local sizes = self:computeChildSizes(buffer:getWidth())
    local xOffset = 0

    buffer:clear()

    local wUsed = 0
    for i, size in ipairs(sizes) do wUsed = wUsed + size.w end
    local wRemaining = buffer:getWidth() - wUsed

    if (wRemaining > 0) then
        if (self:getAlign() == Kevlar.ContentAlign.Center) then
            xOffset = math.floor(wRemaining / 2)
        elseif (self:getAlign() == Kevlar.ContentAlign.End) then
            xOffset = wRemaining
        end
    end

    for i, size in ipairs(sizes) do
        child = self:getChildren()[i]
        child:setSize(size.w, size.h)
        child:update()
        child:draw(buffer:base():sub(xOffset + 1, 1, size.w, size.h))

        xOffset = xOffset + size.w
    end
end

--- <returns type="number"></returns>
function HorizontalBranch:computeHeight(w)
    local sizes = self:computeChildSizes(w)
    local highest = 0

    for i, size in ipairs(sizes) do
        if (size.h > highest) then
            highest = size.h
        end
    end

    return highest
end

function HorizontalBranch:computeChildSizes(wMax)
    local child = Kevlar.Node.as(nil)
    local wUsed = 0
    local eligible = { }
    local stretched = { }
    local dynamic = { }
    local minWidths = { }

    for i, child in ipairs(self:getChildren()) do
        local minWidth
        local sizingMode = child:getSizing()

        if (sizingMode == Kevlar.Sizing.Fixed) then
            minWidth = child:getWidth()
        else
            minWidth = child:computeWidth(nil)

            if (sizingMode == Kevlar.Sizing.Stretched) then
                table.insert(stretched, i)
            elseif (sizingMode == Kevlar.Sizing.Dynamic) then
                table.insert(dynamic, i)
            end
        end

        wUsed = wUsed + minWidth

        table.insert(eligible, child)
        table.insert(minWidths, minWidth)

        if (wUsed >= wMax) then
            break
        end
    end

    --- allocate extra space for stretched
    if (wUsed < wMax) then
        local remaining = wMax - wUsed

        if (#stretched > 0) then
            local wEach = math.floor(remaining / #stretched)
            remaining = remaining -(wEach * #stretched)

            for i, v in ipairs(stretched) do
                if (i <= remaining) then
                    minWidths[v] = minWidths[v] + wEach + 1
                else
                    minWidths[v] = minWidths[v] + wEach
                end
            end
        elseif (#dynamic > 0) then
            for k, i in ipairs(dynamic) do
                child = eligible[i]

                local possibleWidth = child:computeWidth(1)

                if (possibleWidth > minWidths[i]) then
                    local allocated = math.min(possibleWidth, remaining)
                    minWidths[i] = allocated
                    remaining = remaining - allocated

                    if (remaining < 1) then
                        break
                    end
                end
            end
        end
    end

    local sizes = { }

    for i, child in ipairs(eligible) do
        local w = minWidths[i]
        local h

        if (child:getSizing() == Kevlar.Sizing.Fixed) then
            h = child:getHeight()
        else
            h = child:computeHeight(w)
        end

        table.insert(sizes, { h = h, w = w })
    end

    return sizes
end

function HorizontalBranch:addChild(node, name)
    self.super().addChild(self, node, name)
end

function HorizontalBranch:getChildren()
    return self.super().getChildren(self)
end

function HorizontalBranch:removeChildren()
    return self.super().removeChildren(self)
end

function HorizontalBranch:setAlign(align)
    self.super().setAlign(self, align)
end

function HorizontalBranch:getAlign()
    return self.super().getAlign(self)
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.HorizontalBranch = HorizontalBranch