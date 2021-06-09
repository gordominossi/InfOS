-- Import section

Machine = require("data.datasource.machine")

--

local function exec(address, name)
    local multiblock = Machine.getMachine(address, name)
    if not multiblock then return end
    local workAllowed = multiblock:isWorkAllowed()
    multiblock.setWorkAllowed(not workAllowed, multiblock)
end

return exec
