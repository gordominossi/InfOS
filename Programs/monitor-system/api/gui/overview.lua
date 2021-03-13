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

function overview.widgets.update()
    for _, widget in ipairs(overview.widgets) do
        widget:update()
    end
    for i = 1, 9 do
        overview.widgets.active[i] = overview.widgets[9 * (overview.pageIndex - 1) + i]
    end
    Widget.clear()
end

function overview.update()
    overview.widgets.update()
end

function overview.draw()
    for index, activeWidget in ipairs(overview.widgets.active) do
        activeWidget:draw(index)
    end
end

return overview
