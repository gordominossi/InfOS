-- Import section
Parser = require("utils.parser")
Inherits = require("utils.inherits")
Machine = require("data.datasource.machine")
local mock = require("data.mock.mock-miner")
--

local Miner =
    Inherits(
    Machine,
    {
        mock = mock,
        name = "MultiBlock"
    }
)

function Miner:getName()
    local sensorInformation = self:getSensorInformation()
    return Parser.parseName(sensorInformation[1])
end

function Miner:getWorkArea()
    local sensorInformation = self:getSensorInformation()
    return Parser.parseWorkArea(sensorInformation[2])
end

return Miner
