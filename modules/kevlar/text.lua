local Text = { }

Text.Options = {
    align = nil,
    height = nil,
    hidden = nil,
    sizing = nil,
    text = nil,
    width = nil
}

--- <summary></summary>
--- <returns type="Kevlar.Text"></returns>
function Text.new(opts)
    local instance = Kevlar.Node.new(opts)
    setmetatable(instance, { __index = Text })
    setmetatable(Text, { __index = Kevlar.Node })

    instance:ctor(opts)

    return instance
end

function Text:ctor(opts)
    opts = self.asOptions(opts or { })

    self._text = opts.text or ""
    self._align = opts.align or Kevlar.TextAlign.Left
end

--- <summary></summary>
--- <returns type="Kevlar.Text"></returns>
function Text.as(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Text.Options"></returns>
function Text.asOptions(instance) return instance end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Text:base() return self end

--- <summary></summary>
--- <returns type="Kevlar.Node"></returns>
function Text.super() return Kevlar.Node end

function Text:getLength()
    return string.len(self._text)
end

function Text:getText()
    return self._text
end

function Text:setText(text)
    self._text = text
end

function Text:update()
    local buffer = self:base():getBuffer()
    local lines = self:formatLines(buffer:getWidth(), buffer:getHeight(), self:getAlign())

    for y = 1, #lines do
        buffer:write(1, y, lines[y])
    end
end

--- <returns type="number"></returns>
function Text:computeWidth(h)
    if (h == nil) then
        local words = self:getWords()

        if (#words == 1) then
            return #self:getText()
        end

        local highest = 1

        for i, word in ipairs(words) do
            highest = math.max(highest, #word)
        end

        return highest
    else
        if (h == 1) then
            return #self:getText()
        else
            error("Text:computeWidth(h) not implemented with h => not nil and not 1")
        end
    end
end

--- <returns type="number"></returns>
function Text:computeHeight(w)
    if (w == nil) then
        return 1
    else
        local lines = self:formatLines(w, nil, self:getAlign())

        return #lines
    end
end

--- <returns type="Kevlar.Sizing"></returns>
function Text:getSizing()
    return self.super().getSizing(self)
end

function Text:setSizing(sizing)
    self.super().setSizing(self, sizing)
end

function Text:setAlign(align) self._align = align end
function Text:getAlign() return self._align end

--- <summary>Returns the text as single words</summary>
function Text:getWords()
    return string.split(self._text, " ")
end

--- <summary>Returns the current number of words</summary>
function Text:numWords()
    return #self:getWords()
end

function Text:formatLines(width, maxNumLines, align)
    local lines = self:getLines(width, maxNumLines)
    local formatted = { }

    for i = 1, #lines do
        table.insert(formatted, self:formatLine(lines[i], width, align))
    end

    return formatted
end

function Text:formatLine(line, width, align)
    if (align == Kevlar.TextAlign.Justify) then
        if (#line == 1) then return self:formatLine(line, width, Kevlar.TextAlign.Left) end

        local length = #(table.concat(line, ""))
        local rest = width - length
        local numSpacesEach = math.max(0, math.floor(rest /(#line - 1)))
        local leftOver = rest %(#line - 1)

        if (length < numSpacesEach * #line) then
            return self:formatLine(line, width, Kevlar.TextAlign.Left)
        end

        local lineText = ""

        if (leftOver == 0) then
            lineText = table.concat(line, string.rep(" ", numSpacesEach))
        else
            for e = 1, #line do
                if (e == #line) then
                    lineText = lineText .. line[e]
                elseif (e <= leftOver) then
                    lineText = lineText .. line[e] .. string.rep(" ", numSpacesEach + 1)
                else
                    lineText = lineText .. line[e] .. string.rep(" ", numSpacesEach)
                end
            end
        end

        if (#lineText > width) then lineText = lineText:sub(1, width) end

        return lineText
    else
        local lineText = table.concat(line, " ")
        if (#lineText > width) then lineText = lineText:sub(1, width) end

        if (align == Kevlar.TextAlign.Center) then
            local rest = width - #lineText
            if (rest < 0) then return lineText end

            return string.rep(" ", math.ceil(rest / 2)) .. lineText .. string.rep(" ", math.floor(rest / 2))
        elseif (align == Kevlar.TextAlign.Left) then
            local rest = width - #lineText
            if (rest < 0) then return lineText end
            return lineText .. string.rep(" ", rest)
        elseif (align == Kevlar.TextAlign.Right) then
            local rest = width - #lineText
            if (rest < 0) then return lineText end

            return string.rep(" ", rest) .. lineText
        end
    end
end

function Text:getLines(width, maxNumLines)
    local words = self:getWords()
    local lines = { }
    local line = { }
    local lineLength = 0

    lines[#lines + 1] = line

    for i = 1, #words do
        local word = words[i]

        if (#line == 0) then
            line[#line + 1] = word
            lineLength = lineLength + #word
        elseif (lineLength + #word + 1 <= width) then
            line[#line + 1] = word
            lineLength = lineLength + #word + 1
        else
            if (maxNumLines ~= nil and #lines >= maxNumLines) then
                break
            end

            line = { }
            lines[#lines + 1] = line
            line[#line + 1] = word
            lineLength = #word
        end
    end

    return lines
end

if (Kevlar == nil) then Kevlar = { } end
Kevlar.Text = Text