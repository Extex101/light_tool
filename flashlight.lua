
local flashlight_max_charge = 30000

local S = technic.getter

technic.register_power_tool("technic:flashlight", flashlight_max_charge)

minetest.register_tool("technic:flashlight", {
	description = S("Flashlight"),
	inventory_image = "technic_flashlight.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
})

minetest.register_craft({
	output = "technic:flashlight",
	recipe = {
		{"technic:rubber",                "default:glass",   "technic:rubber"},
		{"technic:stainless_steel_ingot", "technic:battery", "technic:stainless_steel_ingot"},
		{"",                              "technic:battery", ""}
	}
})


local function check_for_flashlight(player)
	if player == nil then
		return false
	end
	local inv = player:get_inventory()
	local hotbar = inv:get_list("main")
	for i = 1, 8 do
		if hotbar[i]:get_name() == "technic:flashlight" then
			local meta = minetest.deserialize(hotbar[i]:get_metadata())
			if meta and meta.charge and meta.charge >= 2 then
				if not technic.creative_mode then
					meta.charge = meta.charge - 2;
					technic.set_RE_wear(hotbar[i], meta.charge, flashlight_max_charge)
					hotbar[i]:set_metadata(minetest.serialize(meta))
					inv:set_stack("main", i, hotbar[i])
				end
				return true
			end
		end
	end
	return false
end

minetest.register_globalstep(function(dtime)
	for i, player in pairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		local flashlight_weared = check_for_flashlight(player)
		local pos = player:get_pos()
		local dir = player:get_look_dir()
		local rounded_pos = vector.round(pos)
		rounded_pos.y = rounded_pos.y + 1
		
		if flashlight_weared then
			light_tool.light_beam({x=pos.x, y=pos.y+1, z=pos.z}, dir, 20)
		end
	end
end)
