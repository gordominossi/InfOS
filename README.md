# InfOS
A collection of OpenComputers code for automated information gathering, displaying and automation.

This was made to be used in the Gregtech: New Horizons modpack, but you can use it as you please.

For better developing and debbuging, I sugest installing OCEmu.

## A fork of Sampsa's InfOS

### This fork contains monitor-system, a program to
- Monitor power and machine states and display them in nifty little widgets on an OpenComputers screen,
- Configure and display widgets on OpenGlasses2 HUD,
- Display holograms in then world to aid the player in finding the machine that needs maintenance,
- Disable machines that require a cleanroom when it is not at 100% efficiency,
- Notify about important events in one's base, such as power loss or need for maintenance,
- Work nice with shaders
- Work with OCEmu

## Installation for development
- Download and setup OCEmu
- Find The directory in your system corresponding to the OCEmu disk
- cd into `diskname/home`
- Clone this repo
- Run `ln -s lib InfOS/lib`
- Run `ln -s .shrc InfOS/.shrc`
- Run `ln -s setup InfOS/setup`

## Installation for ingame use
- Open your OpenComputer
- Paste `wget https://raw.githubusercontent.com/gordominossi/InfOS/master/setup.lua -f` into the terminal and run it
- Run `setup`
- Enjoy

## Configuration for your machines
- Unfortunately, as the code is right now, you'll have to configure each machine by hand, which means putting their addresses and names into the correct addresses files
- There will be an update that detects new machines and another one that facilitates the initial setup (See issue #21)

### Screenshot
![Shaders on!](2021-01-11_17.14.29.png)
