local Text = { }

Text.Align = {
    Left = 1,
    Center = 2,
    Right = 3,
    Justify = 4
}

--- <summary></summary>
--- <returns type="Kevlar.Text"></returns>
function Text.new(text, align, w, h)
    local instance = Kevlar.Node.new(w, h)
    setmetatable(instance, { __index = Text })
    setmetatable(Text, { __index = Kevlar.Node })

    text = text or ""
    align = align or Text.Align.Left

    instance:ctor(text, align)

    return instance
end

function Text:ctor(text, align)
    self._text = text
    self._align = align

    self:base():onEvent(Kevlar.Event.Type.Char, function(ev)
        self._text = self._text .. ev:getValue()
    end )

    self:base():onEvent(Kevlar.Event.Type.Key, function(ev)
        local key = ev:getValue()

        if (key == keys.backspace) then
            self._text = string.sub(self._text, 1, math.max(0, #self._text - 1))
        end
    end )
end

--- <summary></summary>
--- <returns type="Kevlar.Text"></returns>
function Text.as(instance) return instance end

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
        local highest = 0

        for i, word in ipairs(self:getWords()) do
            if (#word > highest) then
                highest = #word
            end
        end

        return highest
    else
        error("Text:computeWidth(h) not implemented")
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
    if (align == Text.Align.Justify) then
        if (#line == 1) then return self:formatLine(line, width, Text.Align.Left) end

        local length = #(table.concat(line, ""))
        local rest = width - length
        local numSpacesEach = math.max(0, math.floor(rest /(#line - 1)))
        local leftOver = rest %(#line - 1)

        if (length < numSpacesEach * #line) then
            return self:formatLine(line, width, Text.Align.Left)
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

        if (align == Text.Align.Center) then
            local rest = width - #lineText
            if (rest < 0) then return lineText end

            return string.rep(" ", math.ceil(rest / 2)) .. lineText .. string.rep(" ", math.floor(rest / 2))
        elseif (align == Text.Align.Left) then
            local rest = width - #lineText
            if (rest < 0) then return lineText end
            return lineText .. string.rep(" ", rest)
        elseif (align == Text.Align.Right) then
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