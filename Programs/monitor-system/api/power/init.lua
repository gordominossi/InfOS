-- Import section

local energyBuffersAddresses = require("config.addresses.energy-buffers")
local getPowerStatusUsecase = require("domain.energy.get-energy-status-usecase")

--

local power = {}

function power.update()
    local powerStatuses = {}
    for name, address in pairs(energyBuffersAddresses) do
        powerStatuses[address] = getPowerStatusUsecase(address, name)
    end
    local consolidatedPowerStatus = {
        progress = 0,
        maxProgress = 0,
        dProgress = 0,
        timeToFull = 0,
        timeToEmpty = 0,
        state = {}
    }
    for address, status in pairs(powerStatuses) do
        consolidatedPowerStatus.progress = consolidatedPowerStatus.progress + status.progress
        consolidatedPowerStatus.maxProgress = consolidatedPowerStatus.maxProgress + status.maxProgress
        consolidatedPowerStatus.dProgress = status.dProgress
        consolidatedPowerStatus.timeToFull = consolidatedPowerStatus.timeToFull + (status.timeToFull or 0)
        consolidatedPowerStatus.timeToEmpty = consolidatedPowerStatus.timeToEmpty + (status.timeToEmpty or 0)
        consolidatedPowerStatus.state = status.state
    end
    return consolidatedPowerStatus
end

return power
