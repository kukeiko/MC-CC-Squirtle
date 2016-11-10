local Disk = { }

--- <summary>
--- directory: (string) directory name
--- recursive?: (bool) defaults to false
--- files?: (table)
--- </summary>
--- <returns type="Scripts"></returns>

function Disk.getFiles(directory, recursive, files)
    recursive = recursive or false
    files = files or { }

    for k, v in pairs(fs.list(directory)) do
        local absolute = Disk.combine(directory, v)
        absolute = "/" .. absolute

        if (fs.isDir(absolute)) then
            if (recursive) then
                Disk.getFiles(absolute, true, files)
            end
        else
            table.insert(files, absolute)
        end
    end

    return files
end

function Disk.move(from, to)
    if(Disk.exists(to)) then
        Disk.delete(to)
    end

    return fs.move(from, to)
end

function Disk.exists(path)
    return fs.exists(path)
end

function Disk.delete(path)
    return fs.delete(path)
end

function Disk.combine(...)
    local args = { ...}
    local path = ""

    for k, v in ipairs(args) do
        path = fs.combine(path, v)
    end

    return path
end

function Disk.loadTable(path)
    if (not fs.exists(path)) then error("File not found") end

    local file = fs.open(path, "r")
    local data = textutils.unserialize(file.readAll())
    file.close()

    return data
end

function Disk.tryLoadTable(path)
    if (not fs.exists(path)) then return nil, "File not found" end

    local file = fs.open(path, "r")
    local data = textutils.unserialize(file.readAll())
    file.close()

    return data
end

function Disk.saveTable(path, t)
    local directory = Disk.getDirectoryName(path)

    if (directory and not fs.exists(directory)) then
        fs.makeDir(directory)
    end

    local contents = textutils.serialize(t)
    local file = fs.open(path, "w")

    file.write(contents)
    file.close()
end

function Disk.getDirectoryName(path)
    local fileName = fs.getName(path)

    if (fileName:len() == path:len()) then return nil end

    return path:sub(1, path:len() - fileName:len() -1)
end

if (Core == nil) then Core = { } end
Core.Disk = Disk
