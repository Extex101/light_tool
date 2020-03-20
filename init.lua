local name = minetest.get_current_mod_name()
local path = minetest.get_modpath(name)

dofile(path.."/api.lua")

minetest.register_tool("light_tool:light_tool", {
	description = "Light Tool",
	inventory_image = "light_tool_light_tool.png",
})
light_tool.add_tool("light_tool:light_tool", 20)

minetest.register_node("light_tool:light", {
	drawtype = "airlike",
	tiles = {"blank.png"},
	paramtype = "light",
	walkable = false,
	sunlight_propagates = true,
	light_source = 8,
	pointable = false,
	buildable_to = true, 
	on_construct = function(pos)
		minetest.after(0.1, function()
			minetest.set_node(pos, {name = "air"})
		end)
	end,
})

minetest.register_lbm({
	name = "light_tool:remove_light",
	nodenames = {"light_tool:light"},
	run_at_every_load = true, 
	action = function(pos, node)
		minetest.set_node(pos, {name = "air"})
	end,
})

if minetest.get_modpath("default") then
	light_tool.register_glow_node("default:water_source")
	light_tool.register_glow_node("default:water_flowing")
	light_tool.register_glow_node("default:river_water_source")
	light_tool.register_glow_node("default:river_water_flowing")
	
	minetest.register_craft({
		output = "light_tool:light_tool",
		recipe = {
			{"","default:mese_crystal_fragment","default:mese_crystal"},
			{"default:mese_crystal_fragment","default:steel_ingot","default:mese_crystal_fragment"},
			{"default:steel_ingot", "default:mese_crystal_fragment",""},
		},
	})
end
if minetest.get_modpath("mcl_core") then
	light_tool.register_glow_node("mcl_core:water_source")
	light_tool.register_glow_node("mcl_core:water_flowing")
	minetest.register_craft({
		output = "light_tool:light_tool",
		recipe = {
			{"","mcl_mobitems:blaze_rod","mcl_nether:glowstone"},
			{"mcl_mobitems:blaze_rod","mcl_core:steel_ingot","mcl_mobitems:blaze_rod"},
			{"mcl_core:steel_ingot", "mcl_mobitems:blaze_rod",""},
		},
	})
end
minetest.register_globalstep(function()
	for _, user in ipairs(minetest.get_connected_players()) do
		local stack = ItemStack(user:get_wielded_item())
		local wielded = stack:get_definition()
		if light_tool.check(light_tool.tools, wielded.name) then
			local index = light_tool.check_index(light_tool.tools, wielded.name)
			local dir = user:get_look_dir()
			local pos = user:get_pos()
			light_tool.light_beam({x = pos.x, y = pos.y+1, z = pos.z}, dir, light_tool.range[index])
		end
	end
end)
