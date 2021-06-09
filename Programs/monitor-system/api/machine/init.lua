-- Import section

local cleanroomAddresses = require("config.addresses.cleanroom")
local protectCleanroomUsecase = require("domain.cleanroom.protect-recipes-usecase")

local multiblockAddresses = require("config.addresses.multi-blocks")
local getMultiblockStatusUsecase = require("domain.multiblock.get-multiblock-status-usecase")

--

local machine = {}

function machine.update(powerStatus)
    -- TODO: turn off machines before power runs out
    local cleanroomStatus = protectCleanroomUsecase(cleanroomAddresses)
    local multiblockStatuses = {}
    for name, address in ipairs(multiblockAddresses) do
        multiblockStatuses[address] = getMultiblockStatusUsecase(address, name)
    end
    return {
        cleanroomStatus = cleanroomStatus,
        multiblockStatuses = multiblockAddresses
    }
end

return machine
