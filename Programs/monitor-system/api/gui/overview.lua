-- Import section

local multiBlockAddresses = require("config.addresses.multi-blocks")

--

--[[
|gla| overview  |
|wid| w | w | w |
|hel| w | w | w |
|sto| w | w | w |
|not| power |b|f|
--]]
local overview = {
    title = "Overview",
    pageIndex = 1,
    widgets = {
        active = {}
    }
}

for name, address in pairs(multiBlockAddresses) do
    table.insert(overview.widgets, Widget.createMachineWidget(address, name))
end

return overview
