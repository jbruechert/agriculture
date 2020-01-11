--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2016-2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

--
-- API
--

local function drop_random(pos, item)
	core.add_item({x = pos.x + math.random(-25, 25)/100, y = pos.y,
		z = pos.z + math.random(-25, 25)/100}, item)
end

--[[
Registers a garden node which drops a random set of seeds.

def.description: If not defined, "Garden" is used.
def.items: List of items that can possibly be dropped
def.number_of_drops: Average number of items dropped
def.texture: If tiles is not defined, this is used as texture for all sides.
]]
function agriculture.register_garden(name, def)
	local items = def.items
	local number_of_drops = def.number_of_drops or 2

	def.description = def.description or "Garden"
	def.paramtype = "light"
	def.drawtype = "plantlike"
	def.tiles = def.tiles or {def.texture}
	def.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		core.remove_node(pos)
		core.add_item(pos, name)
	end
	def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		for i = 1, number_of_drops + math.random(-1, 1) do
			local item = items[math.random(1, #items)]
			drop_random(pos, item)
		end
	end
	def.sunlight_propagates = true
	def.walkable = false
	def.groups = def.groups or {}
	def.groups.garden = 1
	def.groups.attached_node = 1
	def.groups.snappy = 3
	def.groups.flora = 1
	def.drop = ""

	-- clean up
	def.items = nil
	def.number_of_drops = nil

	core.register_node(name, def)
end

--
-- Gardens
--

agriculture.register_garden("agriculture:garden", {
	items = agriculture.registered_seeds,
	texture = "agriculture_garden.png",
})

-- TODO: Add more different gardens for different biomes (e.g. tropical garden for rainforests)

--
-- MapGen
--

function agriculture.register_garden_decoration(name, def)
	def = def or {}
	def.fill_ratio = def.fill_ratio or 0.00008

	core.register_decoration({
		deco_type = "simple",
		place_on = def.place_on or {"default:dirt_with_grass"},
		sidelen = 16,
		fill_ratio = def.fill_ratio,
		biomes = def.biomes,
		y_min = 3,
		y_max = 80,
		decoration = name,
	})
end

if core.get_mapgen_params().mgname == "v6" then
	agriculture.register_garden_decoration("agriculture:garden")
else
	agriculture.register_garden_decoration("agriculture:garden", {
		biomes = {"grassland", "floatland_grassland", "deciduous_forest"},
	})
	agriculture.register_garden_decoration("agriculture:garden", {
		biomes = {"coniferous_forest", "savanna", "floatland_coniferous_forest"},
		fill_ratio = 0.00004,
		place_on = {"default:dirt_with_grass", "default:dirt_with_dry_grass"}
	})
end
