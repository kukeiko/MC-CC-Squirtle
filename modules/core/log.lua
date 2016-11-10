local Log = {
    _lines = { }
}

function Log.debug(...)
    local args = { ...}
    local msg = ""

    for i = 1, #args do
        if (#msg > 0) then msg = msg .. " " end
        msg = msg .. tostring(args[i])
    end

    table.insert(Log._lines, msg)
end

function Log.error(...)
    Log.debug(...)
end

function Log.debugTable(t)
    table.insert(Log._lines, textutils.serialize(t))
end

function Log.dump()
    Log.dumpToFile()
end

--- <summary>
--- filepath?: defaults to log.txt
--- append?: defaults to true
--- </summary>
function Log.dumpToFile(filepath, append)
    filepath = filepath or "log.txt"

    local mode = "a"
    if (append == false) then mode = "w" end

    local f = fs.open(filepath, mode)
    for i = 1, #Log._lines do f.writeLine(Log._lines[i]) end

    f.close()
    Log.flush()
end

function Log.flush()
    Log._lines = { }
end

if (Core == nil) then Core = { } end
Core.Log = Log
