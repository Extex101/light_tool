-- You can use light_tool.add_tool(<ItemStack>, range) to define your own torches
-- and you can use light_tool.light_beam(pos, dir, range) to define your own light beam

light_tool = {}
light_tool.tools = {}
light_tool.range = {}
light_tool.light_beam = function(pos, dir, range)
	for i = 0, range do
        local new_pos = {
           x = pos.x + (dir.x * i),
           y = pos.y  + (dir.y * i),
           z = pos.z + (dir.z * i),
        }
		local node = minetest.get_node(new_pos)
        if minetest.get_node(new_pos).name == "air" or minetest.get_node(new_pos).name == "light_tool:light"  then
            minetest.set_node(new_pos, {name = "light_tool:light"})
        elseif minetest.registered_nodes[node.name].sunlight_propagates == false then
			break
		end
     end
end

light_tool.add_tool = function(toolname, range)
	table.insert(light_tool.tools, toolname)
	table.insert(light_tool.range, range)
end

light_tool.check = function(table, value)
	for i,v in ipairs(table) do
		if v == value then
			return true
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
