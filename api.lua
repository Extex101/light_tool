-- You can use light_tool.add_tool(<ItemStack>, range) to define your own torches
-- and you can use light_tool.light_beam(pos, dir, range) to define your own light beam
-- also you can use  light_tool.register_glow_node(name) to make it so the beam travels through that block (e.g. To make it work underwater)

light_tool = {}
light_tool.tools = {}
light_tool.range = {}
light_tool.lightable_nodes = {}
light_tool.lit_nodes = {}
light_tool.light_beam = function(pos, dir, range)
	for i = 0, range do
        local new_pos = light_tool.directional_pos(pos, dir, i)
		local node = minetest.get_node(new_pos)
		
		
		local lightable = light_tool.check(light_tool.lightable_nodes, node.name)
		local lit = light_tool.check(light_tool.lit_nodes, node.name)

		if node.name == "air" then
			-- Place temporary light nodes in air:
			minetest.set_node(new_pos, {name = "light_tool:light"})
			minetest.get_node_timer(new_pos):start(0.2)
		elseif node.name == "light_tool:light" then
			-- Extend lifetime for this light node:
			minetest.get_node_timer(new_pos):start(0.2)
        elseif lightable then
			-- Place temporary glow node in lightable node:
			local index = light_tool.check_index(light_tool.lightable_nodes, node.name)
			minetest.set_node(new_pos, {name = light_tool.lightable_nodes[index].."_glowing"})
			minetest.get_node_timer(new_pos):start(0.2)
		elseif node.name == lit then
			-- Extend lifetime for this glow node:
			minetest.get_node_timer(new_pos):start(0.2)
        elseif node.name and minetest.registered_nodes[node.name].sunlight_propagates == false and not lightable and not lit then
			break
		end
     end
end

light_tool.add_tool = function(toolname, range)
	table.insert(light_tool.tools, toolname)
	table.insert(light_tool.range, range)
end

light_tool.register_glow_node = function(name)
	-- Thanks to duane from the MT forums for helping me with this function
	if not (name and type(name) == 'string') then
		return
	end
	if not minetest.registered_nodes[name] then
		return
	end
	
	-- The following creates a temporary light source definition, which forms the light beam of a flashlight.
	-- When you constructed such nodes, call minetest.get_node_timer(pos):start(lifetime) to make it delete itself.
	-- Call start() again to extend the lifetime.
	local node = minetest.registered_nodes[name]
	local def = table.copy(node)
	
	def.paramtype = "light"
	def.light_source = 4
	def.on_timer = function(pos)
		minetest.set_node(pos, {name = name})
	end

	minetest.register_node(":"..name.."_glowing", def)
	table.insert(light_tool.lightable_nodes, name)
	table.insert(light_tool.lit_nodes, name.."_glowing")

	minetest.register_lbm({
		name = ":"..name.."_glowing_removal",
		nodenames = {name.."_glowing"},
		run_at_every_load = true, 
		action = function(pos, node)
			minetest.set_node(pos, {name = name})
		end,
	})
end
light_tool.directional_pos = function(pos, direction, multiplier, addition)
	if addition == nil then
		addition = 0
	end
	return vector.floor({
		x = pos.x + (direction.x * multiplier+addition),
		y = pos.y  + (direction.y * multiplier+addition),
        z = pos.z + (direction.z * multiplier+addition),
	})
end
light_tool.falling_node_check = function(pos, dist)
	--return false --function is currently unstable
	local objects = minetest.get_objects_inside_radius(pos, dist)
	for i, ob in pairs(objects) do
		local en = ob:get_luaentity()
		if en and en.name == "__builtin:falling_node" then
			return true
		end
	end
	return false
	--
end

light_tool.check = function(table, value)
	for i,v in ipairs(table) do
		if v == value then
			return true
		else
			return false
		end
	end
end

light_tool.check_index = function(table, value)
	for i,v in ipairs(table) do
		if v == value then
			return i
		end
	end
end
