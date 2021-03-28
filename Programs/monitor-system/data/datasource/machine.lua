-- Import section
SingleBlock = require("data.datasource.single-block")
--

local machine = {}
local machines = {}

machine.states = {
    ON = {name = "ON", color = Colors.workingColor},
    IDLE = {name = "IDLE", color = Colors.idleColor},
    OFF = {name = "OFF", color = Colors.offColor},
    BROKEN = {name = "BROKEN", color = Colors.errorColor},
}

function machine.getMachine(address, name)
    -- if machines[address] then
    --     return machines[address]
    -- else
        local mach = SingleBlock:new(address, name)
        machines[address] = mach
        return mach
    -- end
end

return machine
