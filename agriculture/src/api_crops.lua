--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2016-2020 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

-- MT 0.4 compatibility
if not core.get_heat then
	core.get_heat = function(pos)
		return nil
	end
end
if not core.get_humidity then
	core.get_humidity = function(pos)
		return nil
	end
end

local function round_number(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

--[[
Places a seed, if the pointed_thing is a valid soil
]]
function agriculture.place_seed(itemstack, placer, pointed_thing, plantname)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end

	local under = core.get_node(pt.under)
	local above = core.get_node(pt.above)

	if core.is_protected(pt.under, placer:get_player_name()) then
		core.record_protection_violation(pt.under, placer:get_player_name())
		return
	end
	if core.is_protected(pt.above, placer:get_player_name()) then
		core.record_protection_violation(pt.above, placer:get_player_name())
		return
	end


	-- return if any of the nodes is not registered
	if not core.registered_nodes[under.name] then
		return
	end
	if not core.registered_nodes[above.name] then
		return
	end

	-- check if pointing at the top of the node
	if pt.above.y ~= pt.under.y + 1 then
		return
	end

	-- check if you can replace the node above the pointed node
	if not core.registered_nodes[above.name].buildable_to then
		return
	end

	-- check if pointing at soil
	if core.get_item_group(under.name, "soil") < 2 then
		return
	end

	-- add the node and remove 1 item from the itemstack
	core.set_node(pt.above, {name = plantname, param2 = 1})

	if not core.settings:get_bool("creative_mode") then
		itemstack:take_item()
	end
	return itemstack
end

--[[
Returns true, if the plant should be replaced by a dry shrub.
]]
function agriculture.is_plant_dying(pos, cond)
	-- Check heat
	local heat = core.get_heat(pos)
	if heat and (heat < cond.heat.min or heat > cond.heat.max) then
		return true
	end

	-- Check humidity
	local humidity = core.get_humidity(pos)
	if humidity and (humidity < cond.humidity.min or humidity > cond.humidity.max) then
		return true
	end

	return false
end

--[[
Returns true, if the plant can grow to the next step.
]]
function agriculture.can_grow_crop(pos, cond)
	if not pos or not cond then
		return false
	end

	-- Soil
	local soilnode = core.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not soilnode then
		return false
	end

	-- Check soil fertility
	local fert = false
	for _, f in pairs(cond.fertility) do
		if core.get_item_group(soilnode.name, f) ~= 0 then
			fert = true
		end
	end
	if not fert then
		return false
	end

	-- Check if soil is wet: do not grow on dry soil
	if core.get_item_group(soilnode.name, "soil") < 3 then
		return false
	end

	-- Check light
	local light = core.get_node_light(pos)

	if not light or light < cond.light.min or light > cond.light.max then
		return false
	end

	return not agriculture.is_plant_dying(pos, cond)
end

--[[
Calculates the time for the next growing step and starts the timer.
]]
local function start_timer(pos, growtime, steps, cond)
	local additional_growtime = 0

	--[[
		Growing will take longer, if the optimal conditions are not met. We check:
			- light
			- biome heat
			- biome humidity
	]]

	-- FIXME: light can vary between start/end of the timer
	if cond.light.best and cond.light.slowdown then
		local diff = cond.light.best - core.get_node_light(pos)
		if diff < 0 then
			diff = diff * (-1)
		end

		additional_growtime = additional_growtime + growtime * cond.light.slowdown * diff
	end

	if cond.heat.best and cond.heat.slowdown and core.get_heat(pos) then
		local diff = cond.heat.best - core.get_heat(pos)
		if diff < 0 then
			diff = diff * (-1)
		end

		additional_growtime = additional_growtime + growtime * cond.heat.slowdown * diff
	end

	if cond.humidity.best and cond.humidity.slowdown and core.get_humidity(pos) then
		local diff = cond.humidity.best - core.get_humidity(pos)
		if diff < 0 then
			diff = diff * (-1)
		end

		additional_growtime = additional_growtime + growtime * cond.humidity.slowdown * diff
	end

	growtime = (growtime + additional_growtime) / steps * agriculture.GROW_TIME_FACTOR
	core.get_node_timer(pos):start(math.random(growtime * 0.6, growtime * 1.4))
end

--[[
Sets the plant node to the next step, if conditions for growing are met.

This runs when the timer finishes.
]]
local function next_step(pos, new_name, growtime, steps, cond)
	if not agriculture.can_grow_crop(pos, cond) then
		if agriculture.is_plant_dying(pos, cond) then
			-- plant died, because it was too hot/cold/wet/dry; place dry shrub
			core.set_node(pos, {name = "default:dry_shrub"})
		else
			-- retry growing
			start_timer(pos, growtime, steps, cond)
		end

		return
	end
	-- update plant
	core.set_node(pos, {name = new_name})
end

--[[
Registers a new crop including plant stages, harvest and seed item.
]]
function agriculture.register_crop(name, def)
	if not def.steps or not def.growtime then return false end

	def.modname = def.modname or core.get_current_modname()

	def.texture_prefix = def.texture_prefix or def.modname .. "_" .. name

	def.harvest = def.harvest or {}
	def.seed = def.seed or {}
	def.plant = def.plant or {}

	def.cond = def.cond or {}
	def.cond.fertility = def.cond.fertility or {}

	-- if best conditions are not met, growing will slow down
	def.cond.light = def.cond.light or {
		min = 12,
		max = default.LIGHT_MAX,
		best = default.LIGHT_MAX,
		slowdown = 0.1
	}
	def.cond.heat = def.cond.heat or {
		min = 30,
		max = 80,
		best = 65,
		slowdown = 0.01
	}
	def.cond.humidity = def.cond.humidity or {
		min = 22,
		max = 120,
		best = 60,
		slowdown = 0.008
	}

	if def.has_seed == nil then def.has_seed = true end

	local harvestname = def.harvest.name or def.modname .. ":" .. name
	local seedname
	if def.has_seed == true then
		seedname = def.seed.name or def.modname .. ":" .. name .. "_seed"
	else
		seedname = harvestname
	end

	def.step_after_harvest = tostring(def.step_after_harvest or "1")

	def.garden_groups = def.garden_groups or {"default"}

	-- +-----------------------------------------------------------------------------+
	-- |                                Plant Steps                                  |
	-- +-----------------------------------------------------------------------------+

	local plantdef_base = def.plant or {}

	-- properties for all steps
	plantdef_base.drawtype = plantdef_base.drawtype or "plantlike"
	plantdef_base.waving = 1
	plantdef_base.paramtype = "light"
	plantdef_base.walkable = false
	plantdef_base.buildable_to = true
	plantdef_base.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	}
	plantdef_base.sounds = plantdef_base.sounds or default.node_sound_leaves_defaults()
	plantdef_base.groups = plantdef_base.groups or {snappy = 3, flammable = 2, attached_node = 1}
	plantdef_base.groups.plant = 1
	plantdef_base.groups.not_in_creative_inventory = 1
	for k, v in pairs(def.cond.fertility) do
		plantdef_base.groups[v] = 1
	end

	for i = 1, def.steps do
		local percent = tostring(round_number(100 / def.steps * i, 1))

		-- properties different from step to step
		local plantdef = table.copy(plantdef_base)

		plantdef.description = (def.description or "Plant") .. " (" .. percent .. "% grown)"
		plantdef.tiles = {def.texture_prefix .. "_" .. i .. ".png"}
		plantdef.groups[name] = i

		-- growing
		if def.steps == i then
			-- already fully grown
			plantdef.on_construct = function(pos)
				core.get_meta(pos):set_string("infotext", plantdef.description)
			end

			-- harvest on rightclick, and reimplant
			plantdef.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				if not pos or not node or not player then return end

				core.node_dig(pos, node, player)
				core.set_node(pos, {name = def.modname .. ":" .. name .. "_" .. def.step_after_harvest})
			end
		else
			plantdef.on_construct = function(pos)
				start_timer(pos, def.growtime, def.steps, def.cond)
				core.get_meta(pos):set_string("infotext", plantdef.description)
			end

			plantdef.on_timer = function(pos, elapsed)
				next_step(
					pos,
					def.modname .. ":" .. name .. "_" .. i + 1,
					def.growtime,
					def.steps,
					def.cond
				)
			end
		end

		--
		-- Drop
		--

		if i == def.steps then
			if def.craft_seed_by_harvest then
				-- drop harvest only
				plantdef.drop = def.grown_plant_drop or {
					items = {
						{items = {harvestname}, rarity = 1},
						{items = {harvestname}, rarity = 2},
						{items = {harvestname}, rarity = 3},
						{items = {harvestname}, rarity = 6}
					}
				}
			else
				-- drop harvest + one/two seeds
				plantdef.drop = def.grown_plant_drop or {
					items = {
						max_items = 4,
						{items = {seedname}, rarity = 1},
						{items = {seedname}, rarity = 3},
						{items = {harvestname}, rarity = 1},
						{items = {harvestname}, rarity = 2.2},
						{items = {harvestname}, rarity = 4},
						{items = {harvestname}, rarity = 6}
					}
				}
			end
		else
			-- drop seed
			plantdef.drop = plantdef.drop or seedname
		end

		core.register_node(def.modname .. ":" .. name .. "_" .. i, plantdef)
	end


	-- +-----------------------------------------------------------------------------+
	-- |                                 Items                                       |
	-- +-----------------------------------------------------------------------------+

	--
	-- Seed
	--

	if def.has_seed then
		local seeddef = def.seed
		seeddef.name = nil

		-- properties
		seeddef.description = seeddef.description or def.description .. " Seed"
		seeddef.inventory_image = seeddef.inventory_image or def.texture_prefix .. "_seed.png"

		seeddef.on_place = function(itemstack, placer, pointed_thing)
			return agriculture.place_seed(itemstack, placer, pointed_thing, def.modname .. ":" .. name .. "_1")
		end

		core.register_craftitem(seedname, seeddef)
	end

	--
	-- Harvest
	--

	local harvestdef = def.harvest

	harvestdef.name = nil

	harvestdef.inventory_image = harvestdef.inventory_image or def.texture_prefix .. ".png"
	harvestdef.description = harvestdef.description or def.description

	if def.harvest_implantable == true or def.has_seed == false then
		harvestdef.on_place = function(itemstack, placer, pointed_thing)
			return agriculture.place_seed(itemstack, placer, pointed_thing, def.modname .. ":" .. name .. "_1")
		end
	end

	core.register_craftitem(harvestname, harvestdef)


	-- +-----------------------------------------------------------------------------+
	-- |                                Crafting                                     |
	-- +-----------------------------------------------------------------------------+

	if def.craft_seed_by_harvest then
		core.register_craft({
			output = seedname,
			recipe = {
				{harvestname}
			}
		})
	end

	-- Register garden item, if gardens loaded and garden_groups not empty
	if gardens and next(def.garden_groups) ~= nil then
		gardens.register_garden_item(seedname, def.garden_groups)
	end
end
