# Light Tool

This is a mod that adds a Torch/Flashlight to [Minetest](https://www.minetest.net/) ( [Github Repo](https://github.com/Minetest/minetest))

# Animated gif

Here's how it works


![GIF](https://github.com/Extex101/light_tool/blob/master/in%20use%20(animated).gif)

The beam is obstructed by blocks and go through glass and other nodes (with sunlight_propagates = true)

Minetest forumn topic [here](https://forum.minetest.net/viewtopic.php?f=9&t=23031&p=354005#p354005)

# Technic

I have also added support for technic
But since I can't actually edit the mod itself
I have provided a file "flashlight.lua"
go into your technic mod at mods/technic/technic/tools/
and replace the existing flashlight.lua with the one I have provided
then go into the depends.txt and add light_tool
