--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2016-2020 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

gardens = gardens or {}
gardens.registered_garden_items = {}

-- legacy

core.register_alias("agriculture:garden", "gardens:garden")

--
-- API
--

local function drop_random(pos, item)
	core.add_item({x = pos.x + math.random(-25, 25)/100, y = pos.y,
		z = pos.z + math.random(-25, 25)/100}, item)
end

--[[
Returns a table of items that should be dropped by a garden with the specified garden groups.
]]
function gardens.get_garden_items(garden_groups)
	-- items could be in multiple groups, so we need to use a 'set' (table keys instead of values)
	local itemSet = {}

	for _, group in ipairs(garden_groups) do
		if gardens.registered_garden_items[group] ~= nil then
			for _, item in ipairs(gardens.registered_garden_items[group]) do
				itemSet[item] = true
			end
		end
	end

	-- convert set of items ({example = true, other = false}) into normal table
	local items = {}
	for key, value in pairs(itemSet) do
		if value then
			table.insert(items, key)
		end
	end

	return items
end

--[[
Registers a garden node which drops a random set of seeds.

name: Name of the garden, e.g. "tropical"
def.itemstring: If not defined, "<modname>:<name>_garden"
def.description: If not defined, "Garden" is used.
def.garden_groups: Table of garden groups of which items should be dropped. If not defined, this defaults to {name}.
def.number_of_drops: Average number of items dropped
def.texture: If tiles is not defined, this is used as texture for all sides.
]]
function gardens.register_garden(name, def)
	local itemstring = def.itemstring or core.get_current_modname() .. ":" .. name .. "_garden"
	local items = def.items
	local number_of_drops = def.number_of_drops or 2
	local garden_groups = def.garden_groups or {name}

	def.description = def.description or "Garden"
	def.paramtype = "light"
	def.drawtype = "plantlike"
	def.tiles = def.tiles or {def.texture}
	def.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		core.remove_node(pos)
		core.add_item(pos, name)
	end
	def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local items = gardens.get_garden_items(garden_groups)
	
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
	def.itemstring = nil
	def.garden_groups = nil
	def.number_of_drops = nil

	core.register_node(itemstring, def)
end

--[[
Registers an item to be dropped by specified garden groups.

itemstring: Itemstring of the item to be registered.
garden_groups: Table of garden groups the item should be dropped by, defaults to {"default"}.
]]
function gardens.register_garden_item(itemstring, garden_groups)
	garden_groups = garden_groups or {"default"}

	for _, group in ipairs(garden_groups) do
		if not gardens.registered_garden_items[group] then
			gardens.registered_garden_items[group] = {}
		end

		table.insert(gardens.registered_garden_items[group], itemstring)
	end
end

--
-- Gardens
--

gardens.register_garden("default", {
	itemstring = "gardens:garden",
	texture = "gardens_garden.png",
})

-- TODO: Add more different gardens for different biomes (e.g. tropical garden for rainforests)

--
-- MapGen
--

function gardens.register_garden_decoration(name, def)
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

if core.get_mapgen_setting("mgname") == "v6" then
	gardens.register_garden_decoration("gardens:garden")
else
	gardens.register_garden_decoration("gardens:garden", {
		biomes = {"grassland", "floatland_grassland", "deciduous_forest"},
	})
	gardens.register_garden_decoration("gardens:garden", {
		biomes = {"coniferous_forest", "savanna", "floatland_coniferous_forest"},
		fill_ratio = 0.00004,
		place_on = {"default:dirt_with_grass", "default:dirt_with_dry_grass"}
	})
end
