-- Import section
Widget = require("api.gui.widget")

local multiBlockAddresses = require("config.addresses.multi-blocks")
local getMultiblockStatus = require("domain.multiblock.get-multiblock-status-usaddressesecase")
local toggleMultiblockWork = require("domain.multiblock.toggle-multiblock-work")

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

local function createMachineWidget(address, name)
    local function update(self)
        for key, value in pairs(getMultiblockStatus(address, self.name)) do
            self[key] = value
        end
    end

    local function onClick(self)
        toggleMultiblockWork(address, self.name)
    end

    local machineWidget = {
        name = name,
        type = Widget.types.MULTIBLOCK,
        update = update,
        onClick = onClick,
        getMiddleString = function()
        end,
        draw = Widget.draw
    }

    machineWidget:update()

    return machineWidget
end

for name, address in pairs(multiBlockAddresses) do
    table.insert(overview.widgets, createMachineWidget(address, name))
end

return overview
