-- Import section

Power = require("api.power")
Machines = require("api.machine")
-- Stock = require("api.stock")
-- Notificaction = require("api.notification")
GUI = require("api.gui")
--

local statuses = {}
statuses.powerStatus = Power.update()
statuses.machineStatus = Machines.update(statuses.powerStatus)

GUI.setup(statuses)

while true do
    statuses.powerStatus = Power.update()
    statuses.machineStatus = Machines.update(statuses.powerStatus)
    -- Stock.update()
    -- Notifications.update(statuses)
    GUI.update(statuses)
    os.sleep(0)
end
