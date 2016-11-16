local Kernel = { }

--- should boot unit, shell

--- <summary></summary>
--- <returns type="Squirtle.Kernel"></returns>
function Kernel.new()
    local instance = { }
    setmetatable(instance, { __index = Kernel })
    instance:ctor()

    return instance
end

function Kernel:ctor()
    self._shell = Squirtle.Shell.new(self)
end

--- <summary></summary>
--- <returns type="Squirtle.Kernel"></returns>
function Kernel.as(instance) return instance end

function Kernel:run()
    Core.MessagePump.on("key", function(ev)
        if(ev == keys.f5) then
            os.reboot()
        end
    end, "reboot-handler")

    Core.MessagePump.on("key", function(ev)
        if(ev == keys.f10) then
            Core.MessagePump.quit()
            Core.MessagePump.reset()
        end
    end, "kill-kernel-handler")

--    Core.MessagePump.on("char", function(ev)
--        print(ev)
--    end, "sandbox")

    Core.MessagePump.run(function()
        self._shell:run();
    end)
--- todo: use MessagePump.run
end

if (Squirtle == nil) then Squirtle = { } end
Squirtle.Kernel = Kernel 