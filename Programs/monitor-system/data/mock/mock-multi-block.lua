-- Import section
Inherits = require("utils.inherits")
MockSingleBlock = require("data.mock.mock-single-block")
--

local MockMultiBlock =
    Inherits(
    MockSingleBlock,
    {
        mocks = {},
        name = "MockMultiBlock"
    }
)

function MockMultiBlock:getSensorInformation()
    local mock = MockMultiBlock:getMock(self.address, self.name)
    mock.workProgress = mock.workProgress + 1
    if mock.workProgress > mock.workMaxProgress then
        mock.workProgress = 0
        mock.workMaxProgress = 0
    end
    if mock.workAllowed and not mock.isBroken and math.random(1000) > 999 and not mock.workProgress then
        mock.workMaxProgress = math.random(500)
    end
    mock.isBroken = mock.isBroken or math.random(100000) > 99999
    return {
        "Progress: §a" .. mock.workProgress .. "§r s / §e" .. mock.workMaxProgress .. "§r s",
        "Stored Energy: §a1000§r EU / §e1000§r EU",
        "Probably uses: §c4§r EU/t",
        "Max Energy Income: §e128§r EU/t(x2A) Tier: §eMV§r",
        "Problems: §c" .. (mock.isBroken and 1 or 0) .. "§r Efficiency: §e" .. (mock.isBroken and 0 or 100) .. ".0§r %",
        "Pollution reduced to: §a0§r %",
        n = 6
    }
end

function MockMultiBlock.setWorkAllowed(allow, self)
    local mock = MockMultiBlock:getMock(self.address, self.name)
    if mock.isBroken then
        mock.isBroken = false
    end
    mock.workAllowed = allow
end

return MockMultiBlock
