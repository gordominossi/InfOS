-- Import section
Component = require("component")
New = require("utils.new")
Term = require("term")

local mock = require("data.mock.mock-single-block")
--

local SingleBlock = {
    mock = mock,
    name = "SingleBlock"
}

function SingleBlock:setWorkAllowed(allow)
    return self.block.setWorkAllowed(allow, self.block)
end

function SingleBlock:isWorkAllowed()
    return self.block:isWorkAllowed()
end

function SingleBlock:getAverageElectricInput()
    return self.block.getAverageElectricInput()
end

function SingleBlock:getOwnerName()
    return self.block.getOwnerName()
end

function SingleBlock:getEUStored()
    return self.block.getEUStored()
end

function SingleBlock:getWorkMaxProgress()
    return self.block.getWorkMaxProgress()
end

function SingleBlock:getSensorInformation()
    return self.block:getSensorInformation()
end

function SingleBlock:getEUOutputAverage()
    return self.block.getEUOutputAverage()
end

function SingleBlock:getEUInputAverage()
    return self.block.getEUInputAverage()
end

function SingleBlock:getStoredEU()
    return self.block.getStoredEU()
end

function SingleBlock:isMachineActive()
    return self.block.isMachineActive()
end

function SingleBlock:getOutputVoltage()
    return self.block.getOutputVoltage()
end

function SingleBlock:getAverageElectricOutput()
    return self.block.getAverageElectricOutput()
end

function SingleBlock:hasWork()
    return self.block:hasWork()
end

function SingleBlock:getOutputAmperage()
    return self.block.getOutputAmperage()
end

function SingleBlock:getEUCapacity()
    return self.block.getEUCapacity()
end

function SingleBlock:getWorkProgress()
    return self.block.getWorkProgress()
end

function SingleBlock:getEUMaxStored()
    return self.block.getEUMaxStored()
end

local nMachinesNotFound = 0

function SingleBlock:new(partialAdress, name)
    local machine = New(self)

    local successfull =
        pcall(
        function()
            machine.block = Component.proxy(Component.get(partialAdress))
        end
    )
    if (not successfull) then
        nMachinesNotFound = nMachinesNotFound + 1
        Term.setCursor(1, 1)
        print("Failed to find the machine " .. partialAdress .. ". Failed " .. nMachinesNotFound .. " times.")
        machine.block = self.mock:new(partialAdress, name)
    end

    machine.address = machine.block.address
    machine.name = name

    return machine
end

return SingleBlock
