--[[
	Wrap a function for asynchronous execution.

	The function is wrapped inside a coroutine, which is resumed until it returns from its function body or fails resuming.

	A Thread can be run async- or synchronously.
	If run asynchronously, will execute callbacks provided by user (onCompleted, onProgress, onFailed).
	If run synchronously, will block execution of calling coroutine until the wrapped function either finishes or fails. No callbacks are executed.

	onCompleted: executed when coroutine returns from its function body, with return values passed as arguments
	onProgress: executed when coroutine yields, with return values passed as arguments
	onFailed: executed when resuming the coroutine failed, with error information passed as arguments

	Note: Meant to be used for heavy computational functions that yield to give cpu time to other code.
	Does NOT work with code that relies on os.pullEvent() (like several native apis and almost all turtle functions), use Tasks instead.
--]]

local Thread = {
    _nextThreadId = 1
}

--- <summary></summary>
--- <returns type="Core.Thread"></returns>
function Thread.new(func, ...)
    local instance = { }
    setmetatable(instance, { __index = Thread })

    instance._taskId = "Thread:" .. Thread._nextThreadId
    instance._doQuit = false
    instance._func = func
    instance._args = { ...}
    instance._onCompletedCallbacks = { }
    instance._onProgressCallbacks = { }
    instance._onFailedCallbacks = { }

    Thread._nextThreadId = Thread._nextThreadId + 1

    return instance
end

function Thread:getId() return self._taskId end
function Thread:onCompleted(callback) table.insert(self._onCompletedCallbacks, callback) end
function Thread:onProgress(callback) table.insert(self._onProgressCallbacks, callback) end
function Thread:onFailed(callback) table.insert(self._onFailedCallbacks, callback) end

function Thread:quit()
    self._doQuit = true
end

--[[
	Run the task asynchronously.
--]]
function Thread:run(onCompleted, onProgress, onFailed)
    local coro = coroutine.create(self._func)
    local args = self._args

    local helper = function()
        while (not self._doQuit) do
            local params = { coroutine.resume(coro, unpack(args)) }
            local success = table.remove(params, 1)

            if (not success) then
                if (onFailed) then onFailed(unpack(params)) end
                for k, v in pairs(self._onFailedCallbacks) do v(Errors.generic("Thread", nil, params[1])) end

                return
            else
                if (coroutine.status(coro) == "dead") then
                    if (onCompleted) then onCompleted(unpack(params)) end
                    for k, v in pairs(self._onCompletedCallbacks) do v(unpack(params)) end
                    return
                else
                    for k, v in pairs(self._onProgressCallbacks) do v(unpack(params)) end
                    os.queueEvent(self:getId())
                    coroutine.yield(self:getId())
                end
            end
        end
    end

    os.queueEvent(self:getId())
    Core.MessagePump.create(helper, self:getId())
end

function Thread:runSync()
    local coro = coroutine.create(self._func)
    local args = self._args

    os.queueEvent(self:getId())

    while (true) do
        local params = { coroutine.resume(coro, unpack(args)) }
        --        local success = table.remove(params, 1)

        if (coroutine.status(coro) == "dead") then
            return unpack(params)
        else
            os.queueEvent(self:getId())
            coroutine.yield(self:getId())
        end

        -- 	if(not success) then
        -- 		return unpack(params)
        -- 	else
        -- 		if(coroutine.status(coro) == "dead") then
        -- 			return unpack(params)
        -- 		else
        -- 			os.queueEvent(self:getId())
        -- 			coroutine.yield(self:getId())
        -- 		end
        -- 	end
    end
end

if (Core == nil) then Core = { } end
Core.Thread = Thread
