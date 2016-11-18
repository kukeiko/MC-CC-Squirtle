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
    local minWidths = { }

    for i, child in ipairs(self:getChildren()) do
        local minWidth = child:computeWidth(nil)
        wUsed = wUsed + minWidth

        table.insert(eligible, child)
        table.insert(minWidths, minWidth)

        if (child:getSizing() == Kevlar.Sizing.Stretched) then
            table.insert(stretched, i)
        end

        if (wUsed >= wMax) then
            break
        end
    end

    --- allocate extra space for stretched
    if (wUsed < wMax and #stretched > 0) then
        local remaining = wMax - wUsed
        local wEach = math.floor(remaining / #stretched)
        remaining = remaining -(wEach * #stretched)

        for i, v in ipairs(stretched) do
            if (i <= remaining) then
                minWidths[v] = minWidths[v] + wEach + 1
            else
                minWidths[v] = minWidths[v] + wEach
            end
        end
    end

    local sizes = { }

    for i, child in ipairs(eligible) do
        local w = minWidths[i]
        local h = child:computeHeight(w)

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

if (Kevlar == nil) then Kevlar = { } end
Kevlar.HorizontalBranch = HorizontalBranch