-- Import section
Computer = require("computer")
Unicode = require("unicode")
Event = require("event")
DoubleBuffer = require("graphics.doubleBuffering")
Constants = require("api.gui.constants")
Colors = require("graphics.colors")
Widget = require("api.gui.widget")

--

-- GPU resolution should be 160 x 50.
-- Screen should be 8 x 5 blocks.
-- That way, each block should have a resolution of 20 x 10
-- Organizing the page:
---- Title on top of the page (title)
---- Side panel on the left With a width of 40 pixels (panel)
---- 2 buttons for page navigation (b, f)
------- Each with a width of 20 pixels
---- 1 Power widget on the bottom, with a width of 80 pixels (power)
---- 9 Regular widgets on the right, in a 3 x 3 grid (w)
------ Each one with a width of 40 pixels
--[[
| p |   title   |
| a | w | w | w |
| n | w | w | w |
| e | w | w | w |
| l | power |b|f|
--]]
local page = {}

local pages = {
    glasses = require("api.gui.glasses"),
    widgets = require("api.gui.widgets"),
    help = require("api.gui.help"),
    stock = require("api.gui.stock"),
    notifications = require("api.gui.notifications"),
    overview = require("api.gui.overview")
}
pages[1] = pages.glasses
pages[2] = pages.widgets
pages[3] = pages.help
pages[4] = pages.stock
pages[5] = pages.notifications
pages[6] = pages.overview

local elements = {
    mainSection = {},
    powerWidget = {},
    panelSections = {},
    navigationButtons = {}
}

Event.listen(
    "touch",
    function(_, _, x, y)
        local xContribution = x / Constants.widgetBaseWidth
        local yContribution = 4 * math.floor(y / Constants.widgetBaseHeight)
        local screenIndex = 1 + (math.floor(2 * (xContribution + yContribution))) / 2

        local selected = elements[screenIndex] or elements[screenIndex - 0.5]
        selected:onClick()
    end
)

local function drawTitle(title)
    local x = Constants.widgetBaseWidth
    local y = 1
    local width = math.floor(2.5 * Constants.widgetBaseWidth)
    local height = math.floor(0.8 * Constants.widgetBaseHeight)
    Widget.drawBaseWidget(x, y, width, height, title)
end

local function drawRebootButton()
    local width = math.floor(0.3 * Constants.widgetBaseWidth)
    local height = math.floor(0.6 * Constants.widgetBaseHeight)
    local x = math.floor(3.25 * Constants.widgetBaseWidth) + math.floor((Constants.widgetBaseWidth - width) / 2)
    local y = math.floor((Constants.widgetBaseHeight - height) / 2)
    Widget.drawBaseWidget(x, y, width, height, "Restart")
end

local function drawSidebarButton(index, title)
    local width = math.floor(0.6 * Constants.widgetBaseWidth)
    local height = math.floor(0.6 * Constants.widgetBaseHeight)
    local x = math.floor((Constants.widgetBaseWidth - width) / 2)
    local y = (index - 1) * Constants.widgetBaseHeight + math.floor((Constants.widgetBaseHeight - height) / 2)
    Widget.drawBaseWidget(x, y, width, height, title)
end

local function drawNavigationButton(self, index)
    if not self.active then
        return
    end
    local width = math.floor(0.3 * Constants.widgetBaseWidth)
    local height = math.floor(0.6 * Constants.widgetBaseHeight)
    local x =
        math.floor((2.4 + 0.4 * index) * Constants.widgetBaseWidth) +
        math.floor((Constants.widgetBaseWidth - width) / 2)
    local y = 4 * Constants.widgetBaseHeight + math.floor((Constants.widgetBaseHeight - height) / 2)
    Widget.drawBaseWidget(x, y, width, height, self.title)
end

local function clickNavigationButton(self)
    if not self.active then
        return
    end
    if self.title == "◀" then
        elements.mainSection.pageIndex = elements.mainSection.pageIndex - 1
    else
        elements.mainSection.pageIndex = elements.mainSection.pageIndex + 1
    end
end

local function setupSideBar(button)
    local panelIndex = 1
    for _, pg in ipairs(pages) do
        if pg.title ~= button.title then
            elements.panelSections[panelIndex] = {
                title = pg.title,
                onClick = function()
                    setupSideBar(pg)
                end
            }
            drawSidebarButton(panelIndex, pg.title)
            panelIndex = panelIndex + 1
        else
            elements.mainSection = pg
            drawTitle(pg.title)
        end
    end
    elements[1] = elements.panelSections[1]
    elements[5] = elements.panelSections[2]
    elements[9] = elements.panelSections[3]
    elements[13] = elements.panelSections[4]
    elements[17] = elements.panelSections[5]
end

function page.fake()
    elements.mainSection = Widget.fakeWidgets()
    elements.powerWidget = Widget.fakePowerWidget()
    setupSideBar(pages.overview)
end

function page.setup(statuses)
    elements.powerWidget = Widget.createPowerWidget(statuses.powerStatus)

    elements.navigationButtons[1] = {
        title = "◀",
        active = true,
        update = function(self)
            self.active = elements.mainSection.widgets[elements.mainSection.pageIndex * 9 - 10] ~= nil
        end,
        onClick = clickNavigationButton,
        draw = drawNavigationButton
    }
    elements.navigationButtons[2] = {
        title = "▶",
        active = true,
        update = function(self)
            self.active = elements.mainSection.widgets[elements.mainSection.pageIndex * 9 + 1] ~= nil
        end,
        onClick = clickNavigationButton,
        draw = drawNavigationButton
    }
    elements[20] = elements.navigationButtons[1]
    elements[20.5] = elements.navigationButtons[2]

    elements.rebootButton = {
        onClick = function()
            Computer.shutdown(true)
        end
    }
    drawRebootButton()
    elements[4.5] = elements.rebootButton

    elements[18] = elements.powerWidget
    elements[19] = elements.powerWidget

    setupSideBar(pages.overview)
end

function page.update(statuses)
    for _, widget in ipairs(elements.mainSection.widgets) do
        widget:update(statuses)
    end
    for i = 1, 9 do
        elements.mainSection.widgets.active[i] =
            elements.mainSection.widgets[9 * (elements.mainSection.pageIndex - 1) + i]
    end

    elements[6] = elements.mainSection.widgets.active[1]
    elements[7] = elements.mainSection.widgets.active[2]
    elements[8] = elements.mainSection.widgets.active[3]
    elements[10] = elements.mainSection.widgets.active[4]
    elements[11] = elements.mainSection.widgets.active[5]
    elements[12] = elements.mainSection.widgets.active[6]
    elements[14] = elements.mainSection.widgets.active[7]
    elements[15] = elements.mainSection.widgets.active[8]
    elements[16] = elements.mainSection.widgets.active[9]

    Widget.clear()
    for index, activeWidget in ipairs(elements.mainSection.widgets.active) do
        activeWidget:draw(index)
    end

    elements.powerWidget:update(statuses.powerStatus)
    elements.powerWidget:draw()

    for index, navigationButton in ipairs(elements.navigationButtons) do
        navigationButton:update()
        navigationButton:draw(index)
    end

    DoubleBuffer.drawChanges()
end

return page
