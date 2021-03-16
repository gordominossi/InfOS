-- wget https://raw.githubusercontent.com/gordominossi/InfOS/master/setup.lua -f
local shell = require("shell")

local tarMan = "https://raw.githubusercontent.com/mpmxyz/ocprograms/master/usr/man/tar.man"
local tarBin = "https://raw.githubusercontent.com/mpmxyz/ocprograms/master/home/bin/tar.lua"

shell.setWorkingDirectory("/usr/man")
shell.execute("wget -fq " .. tarMan)
shell.setWorkingDirectory("/bin")
shell.execute("wget -fq " .. tarBin)

local InfOS = "https://github.com/gordominossi/InfOS/releases/latest/download/InfOS.tar"

shell.execute("rm -rf /home/InfOS")
shell.execute("mkdir /home/InfOS")

shell.setWorkingDirectory("/home/InfOS")
print("\nUpdating InfOS")
shell.execute("wget -fq " .. InfOS .. " -f")
print("...")
shell.execute("tar -xf InfOS.tar")
shell.execute("rm -f InfOS.tar")
shell.execute("rm -rf /home/lib")
shell.execute("cp -r lib /home/lib")
shell.execute("cp -f .shrc /home/.shrc")
shell.execute("cp -f setup.lua /home/setup.lua")

print("Success!\n")
