-- Import section
New = require("utils.new")
--

local mockMachine = {
    mocks = {}
}

function mockMachine:getMock(address, name)
    if not address then
        return nil
    end
    if not self.mocks[address] then
        self.mocks[address] = {
            name = name or "fake machine",
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

function mockMachine.setWorkAllowed(allow, self)
    local mock = self:getMock(self.address, self.name)
    if mock.isBroken then
        mock.isBroken = false
    end
    mock.workAllowed = allow
end

function mockMachine:isWorkAllowed()
    local mock = self:getMock(self.address)
    return mock.workAllowed
end

function mockMachine.getAverageElectricInput()
    return 0.0
end

function mockMachine.getOwnerName()
    return "gordominossi"
end

function mockMachine.getEUStored()
    return mockMachine.storedEU
end

function mockMachine.getWorkMaxProgress()
    return mockMachine.workMaxProgress
end

function mockMachine:getSensorInformation()
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

function mockMachine.getEUOutputAverage()
    return mockMachine.EUOutputAverage
end

function mockMachine.getEUInputAverage()
    return mockMachine.EUInputAverage
end

function mockMachine:getStoredEU()
    local mock = self:getMock(self.address)
    return mock.storedEU
end

function mockMachine.isMachineActive()
    return mockMachine.active
end

function mockMachine.getOutputVoltage()
    return mockMachine.outputVoltage
end

function mockMachine.getAverageElectricOutput()
    return 0.0
end

function mockMachine:hasWork()
    local mock = self:getMock(self.address)
    return mock.workProgress < mock.workMaxProgress
end

function mockMachine.getOutputAmperage()
    return mockMachine.outputAmperage
end

function mockMachine:getEUCapacity()
    local mock = self:getMock(self.address)
    return mock.EUCapacity
end

function mockMachine.getWorkProgress()
    return mockMachine.workProgress
end

function mockMachine.getEUMaxStored()
    return mockMachine.EUCapacity
end

function mockMachine:new(address, name)
    return New(self, {address = address, name = name})
end

function mockMachine:getEfficiencyPercentage()
    return 100
end

function mockMachine.getBatteryCharge(slot)
    if slot > 16 then
        return nil
    else
        return 1000000
    end
end

function mockMachine.getMaxBatteryCharge(slot)
    if slot > 16 then
        return nil
    else
        return 1000000
    end
end

return mockMachine
