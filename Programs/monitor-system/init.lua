-- Import section

GUI = require("api.gui")

-- local cleanroomAddresses = require("config.addresses.cleanroom")
local multiBlockAddresses = require("config.addresses.multi-blocks")
local energyBufferAddresses = require("config.addresses.energy-buffers")

--

GUI.setup(energyBufferAddresses.batteryBuffer1, multiBlockAddresses)

while true do
    GUI.update()
    os.sleep(0)
end
