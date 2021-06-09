-- Import section

Machine = require("data.datasource.machine")

--

local function exec(address, name)
    local multiblock = Machine.getMachine(address, name)
    if not multiblock then
        return
    end
    local workAllowed = multiblock:isWorkAllowed()

    local successfull =
        pcall(
        function()
            multiblock.setWorkAllowed(not workAllowed)
        end
    )
    if (not successfull) then
        multiblock:setWorkAllowed(not workAllowed)
    end
end

return exec
