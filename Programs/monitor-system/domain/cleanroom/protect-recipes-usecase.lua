-- Import section
Machine = require("data.datasource.machine")
Alarm = require("api.sound.alarm")
--

local function halt(machines)
    Alarm()
    for _, machine in ipairs(machines) do
        local successfull =
            pcall(
            function()
                machine.setWorkAllowed(false)
            end
        )
        if (not successfull) then
            machine:setWorkAllowed(false)
        end
    end
end

local function resume(machines)
    for _, machine in ipairs(machines) do
        local successfull =
            pcall(
            function()
                machine.setWorkAllowed(true)
            end
        )
        if (not successfull) then
            machine:setWorkAllowed(true)
        end
    end
end

local function exec(cleanroomAddresses)
    local cleanroom = Machine.getMachine(cleanroomAddresses.cleanroom, "Cleanroom")
    if not cleanroom then
        return
    end
    local machines = {}
    for name, address in pairs(cleanroomAddresses) do
        if name ~= "cleanroom" then
            table.insert(machines, Machine.getMachine(address, name))
        end
    end
    if (tonumber(cleanroom:getEfficiencyPercentage()) < 100) then
        if (cleanroom:isWorkAllowed()) then
            halt(machines)

            local successfull =
                pcall(
                function()
                    cleanroom.setWorkAllowed(false)
                end
            )
            if (not successfull) then
                cleanroom:setWorkAllowed(false)
            end
        end
    else
        resume(machines)
        cleanroom.isHalted = false
    end
    return cleanroom.isHalted
end

return exec
