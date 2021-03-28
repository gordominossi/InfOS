-- Import section
Inherits = require("utils.inherits")
MockMachine = require("data.mock.mock-machine")
--

local MockMiner =
    Inherits(
    MockMachine,
    {
        name = "MockMiner"
    }
)

function MockMiner.getSensorInformation()
    return {
        "§9Multiblock Miner§r",
        "Work Area: §a2x2§r Chunks",
        n = 2
    }
end

return MockMiner
