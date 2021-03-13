-- Import section

GUI = require("api.gui")
-- GUI = require("api.power")
-- GUI = require("api.machine")
-- GUI = require("api.notification")
-- GUI = require("api.stock")

--

GUI.setup()

while true do
    GUI.update()
    -- Power.update()
    -- Machines.update()
    -- Notifications.update()
    -- Stock.update()
    os.sleep(0)
end
