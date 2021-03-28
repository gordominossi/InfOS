-- Import section
New = require("utils.new")
--

local MockSingleBlock = {
    mocks = {}
}

function MockSingleBlock:getMock(address, name)
    if not address then
        return nil
    end
    if not self.mocks[address] then
        self.mocks[address] = {
            name = name or "MockSingleBlock",
            workAllowed = true,
            storedEU = 1234,
            active = true,
            outputVoltage = 0,
            outputAmperage = 1,
            EUCapacity = 2048,
            workProgress = 0,
            workMaxProgress = 0,
            isBroken = false,
            address = address
        }
    end
    return self.mocks[address]
end

function MockSingleBlock.setWorkAllowed(allow, self)
    local mock = self:getMock(self.address, self.name)
    if mock.isBroken then
        mock.isBroken = false
    end
    mock.workAllowed = allow
end

function MockSingleBlock:isWorkAllowed()
    local mock = self:getMock(self.address)
    return mock.workAllowed
end

function MockSingleBlock.getAverageElectricInput()
    return 0.0
end

function MockSingleBlock.getOwnerName()
    return "gordominossi"
end

function MockSingleBlock.getEUStored()
    return MockSingleBlock.storedEU
end

function MockSingleBlock.getWorkMaxProgress()
    return MockSingleBlock.workMaxProgress
end

function MockSingleBlock:getSensorInformation()
    local mock = self:getMock(self.address, self.name)
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

function MockSingleBlock.getEUOutputAverage()
    return MockSingleBlock.EUOutputAverage
end

function MockSingleBlock.getEUInputAverage()
    return MockSingleBlock.EUInputAverage
end

function MockSingleBlock.getStoredEU()
    return MockSingleBlock.storedEU
end

function MockSingleBlock.isMachineActive()
    return MockSingleBlock.active
end

function MockSingleBlock.getOutputVoltage()
    return MockSingleBlock.outputVoltage
end

function MockSingleBlock.getAverageElectricOutput()
    return 0.0
end

function MockSingleBlock:hasWork()
    local mock = self:getMock(self.address)
    return mock.workProgress < mock.workMaxProgress
end

function MockSingleBlock.getOutputAmperage()
    return MockSingleBlock.outputAmperage
end

function MockSingleBlock.getEUCapacity()
    return MockSingleBlock.EUCapacity
end

function MockSingleBlock.getWorkProgress()
    return MockSingleBlock.workProgress
end

function MockSingleBlock.getEUMaxStored()
    return MockSingleBlock.EUCapacity
end

function MockSingleBlock:new(address, name)
    return New(self, {address = address, name = name})
end

function MockSingleBlock:getEfficiencyPercentage()
    return 100
end

return MockSingleBlock
