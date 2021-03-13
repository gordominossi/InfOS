-- Import section

local cleanroomAddresses = require("config.addresses.cleanroom")
local protectCleanroomUsecase = require("domain.cleanroom.protect-recipes-usecase")

--

local machine = {}

function machine.update()
    protectCleanroomUsecase(cleanroomAddresses)
end

return machine
