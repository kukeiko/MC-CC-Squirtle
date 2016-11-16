local Shell = { }

--- should host windows

--- <summary></summary>
--- <returns type="Squirtle.Shell"></returns>
function Shell.new(kernel)
    local instance = { }
    setmetatable(instance, { __index = Shell })
    instance:ctor(kernel)

    return instance
end

function Shell:ctor(kernel)
    self._kernel = Squirtle.Kernel.as(kernel)
end

--- <summary></summary>
--- <returns type="Squirtle.Shell"></returns>
function Shell.as(instance) return instance end

function Shell:run()
    local mtr = peripheral.wrap("front")
    --    term.redirect(mtr)
    local t = Kevlar.Terminal.new(term.current())

    local vb = Kevlar.VerticalBranch.new()
    local hb = Kevlar.HorizontalBranch.new()
    hb:setSizing(Kevlar.Node.Sizing.Stretched)
    vb:addChild(hb)

    local khazText = Kevlar.Text.new("khaz foo bla blub moo wow zong zaboika ukulele", Kevlar.Text.Align.Center)
    khazText:setSizing(Kevlar.Node.Sizing.Stretched)
    hb:addChild(khazText)


    local moText = Kevlar.Text.new("mo", Kevlar.Text.Align.Center)
    moText:setSizing(Kevlar.Node.Sizing.Stretched)
    hb:addChild(moText)

    local quakText = Kevlar.Text.new("quak!")
    quakText:setSizing(Kevlar.Node.Sizing.Stretched)
    vb:addChild(quakText)
    --    print(textutils.serialize(hb:computeChildSizes(t:getWidth())))
    --    print(hb:computeHeight(t:getWidth()))
    --    print(hb:computeHeight(10))
    --    local danText = Kevlar.Text.new("dan", Kevlar.Text.Align.Left)
    --    danText:setSizing(Kevlar.Node.Sizing.Stretched)
    --    vb:addChild(danText, "baz")

    local win = Kevlar.Window.new("Sandbox", vb, t:getSize())
    win:update()
    win:draw(t)
    --    print(vb:computeHeight(15))

    local x = 0
    local y = 0

    Core.MessagePump.on("key", function(key)
        if (key == keys.a) then
            x = x - 1
        elseif (key == keys.d) then
            x = x + 1
        elseif (key == keys.w) then
            y = y - 1
        elseif (key == keys.s) then
            y = y + 1
        end

        win:draw(t, x, y)
    end )


end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Shell = Shell