-- Import section

Parser = require("utils.parser")
Component = require("component")
New = require("utils.new")
Term = require("term")
Colors = require("graphics.colors")
Filesystem = require("filesystem")

local mock = require("data.mock.mock-machine")

--

local machine = {
    mock = mock,
    name = "unnamed machine"
}

local machines = {}

machine.states = {
    ON = {name = "ON", color = Colors.workingColor},
    IDLE = {name = "IDLE", color = Colors.idleColor},
    OFF = {name = "OFF", color = Colors.offColor},
    BROKEN = {name = "BROKEN", color = Colors.errorColor},
    MISSING = {name = "NOT FOUND", color = Colors.errorColor}
}

function machine.getMachine(address, name)
    -- if machines[address] then
    --     return machines[address]
    -- else
        local mach = machine:new(address, name)
        machines[address] = mach
        return mach
    -- end
end

local machinesNotFound = {}

function machine:new(partialAdress, name)
    local mach = nil

    local successfull =
        pcall(
        function()
            mach = New(self, Component.proxy(Component.get(partialAdress)))
            machinesNotFound[partialAdress] = nil
        end
    )
    if (not successfull and Filesystem.exists("/home/InfOS/.gitignore")) then
        machinesNotFound[partialAdress] = "not found"
        local nMachinesNotFound = 0
        for _, _ in pairs(machinesNotFound) do
            nMachinesNotFound = nMachinesNotFound + 1
        end

        Term.setCursor(1, 1)
        Term.gpu().setBackground(Colors.black)
        Term.gpu().setForeground(Colors.errorColor)
        print("Failed to find the machine " .. partialAdress .. ". " .. nMachinesNotFound .. " machines not found.")

        mach = New(self, self.mock:new(partialAdress, name))
    end

    return mach
end

-- Multiblocks

function Parser.parseProgress(progressString)
    local current = string.sub(progressString, string.find(progressString, "%ba§"))
    current = tonumber((string.gsub(string.gsub(current, "a", ""), "§", "")))

    local maximum = string.sub(progressString, string.find(progressString, "%be§", (string.find(progressString, "/"))))
    maximum = tonumber((string.gsub(string.gsub(maximum, "e", ""), "§", "")))

    return {current = current, maximum = maximum}
end

function machine:getNumberOfProblems()
    local sensorInformation = self:getSensorInformation()
    return Parser.parseProblems(sensorInformation[5])
end

function machine:getProgress()
    local sensorInformation = self:getSensorInformation()
    return Parser.parseProgress(sensorInformation[1])
end

function machine:getEfficiencyPercentage()
    local sensorInformation = self:getSensorInformation()
    return Parser.parseEfficiency(sensorInformation[5])
end

function machine:getEnergyUsage() -- EU/t
    local maxProgress = self:getWorkMaxProgress() or 0
    if maxProgress > 0 then
        local sensorInformation = self:getSensorInformation()
        return Parser.parseProbablyUses(sensorInformation[3])
    else
        return 0
    end
end

-- Energy provider

function machine:getAllBatteryCharges()
    local batteryCharges = {}
    local i = 1
    while true do
        local successfull =
            pcall(
            function()
                table.insert(batteryCharges, machine.getBatteryCharge(i, self))
            end
        )
        if (not successfull) then
            return batteryCharges
        end

        i = i + 1
    end
end

function machine:getAllBatteryMaxCharges()
    local batteryCharges = {}
    local i = 1
    while true do
        local successfull =
            pcall(
            function()
                table.insert(batteryCharges, machine.getMaxBatteryCharge(i, self))
            end
        )
        if (not successfull) then
            return batteryCharges
        end

        i = i + 1
    end
end

function machine:getBatteryChargesSum()
    local batterySum = 0
    local i = 1
    while true do
        local successfull =
            pcall(
            function()
                batterySum = batterySum + machine.getBatteryCharge(i, self)
            end
        )
        if (not successfull) then
            return batterySum
        end

        i = i + 1
    end
end

function machine:getMaxBatteryChargesSum()
    local batterySum = 0
    local i = 1
    while true do
        local successfull =
            pcall(
            function()
                batterySum = batterySum + machine.getMaxBatteryCharge(i, self)
            end
        )
        if (not successfull) then
            return batterySum
        end

        i = i + 1
    end
end

function machine:getTotalEnergy()
    return {
        current = self:getBatteryChargesSum() + self:getStoredEU(),
        maximum = self:getMaxBatteryChargesSum() + self:getEUCapacity()
    }
end

return machine
