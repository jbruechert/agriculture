--[[
This file is part of the Minetest Mod Compost

Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- compatibility with other compost mods
core.register_alias("compost:wood_barrel", "compost:composter")
core.register_alias("compost:wood_barrel_1", "compost:composter")
core.register_alias("compost:wood_barrel_2", "compost:composter")
core.register_alias("compost:wood_barrel_3", "compost:composter")
core.register_alias("compost:wood_barrel_empty", "compost:composter")

compost = {}

compost.COMPOST_ITEM_VALUE = 100.0

-- time in seconds the composter formspec and node are updated
compost.COMPOSTER_UPDATE_INTERVAL = 1.0

-- increase to make compost processing faster
compost.COMPOSTER_SPEED = 1.0

local COMPOSTER_INV_INPUT = "input"
local COMPOSTER_INV_OUTPUT = "output"
local COMPOSTER_INVENTORIES = {COMPOSTER_INV_INPUT, COMPOSTER_INV_OUTPUT}

compost.registered_compostable_items = {}
compost.registered_compostable_groups = {}

function compost.register_compostable_item(itemstring, value)
	compost.registered_compostable_items[itemstring] = value
end

function compost.register_compostable_group(groupname, value)
	compost.registered_compostable_groups[groupname] = value
end

--[[
	Returns the compost value of an itemstring. Returns 0 if the item is not
	compostable.

	It checks the following:
	 * registered compostable items
	 * "compostable" item group
	 * registered compostable item groups
]]
function compost.get_compost_value(itemstring)
	-- check registered compostable items and "compostable" item group
	local value = compost.registered_compostable_items[itemstring] or
			core.get_item_group(itemstring, "compostable")

	-- check registered compostable item groups
	if value == nil or value < 1 then
		value = 0
		for group, groupValue in pairs(compost.registered_compostable_groups) do
			if core.get_item_group(itemstring, group) > 0 then
				if groupValue and groupValue >= value then
					value = groupValue
				end
			end
		end
	end
	return value
end

function compost.is_compostable_item(itemstring)
	return compost.get_compost_value(itemstring) > 0
end

function compost.get_composter_formspec(pos, meta)
	local compost_percent =
			meta:get_float("processed") / compost.COMPOST_ITEM_VALUE * 100
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z

	return "size[8,8.5]" ..
		"list[nodemeta:" .. spos .. ";input;0.75,0.5;3,3;]" ..
		"list[nodemeta:" .. spos .. ";output;5.25,1;2,2;]" ..
		"image[4,1.5;1,1;gui_furnace_arrow_bg.png^[lowpart:"..
		(compost_percent)..":gui_furnace_arrow_fg.png^[transformR270]"..
		"list[current_player;main;0,4.25;8,1;]" ..
		"list[current_player;main;0,5.5;8,3;8]" ..
		"listring[nodemeta:" .. spos .. ";output]" ..
		"listring[current_player;main]" ..
		"listring[nodemeta:" .. spos .. ";input]" ..
		"listring[current_player;main]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		default.get_hotbar_bg(0, 4.25)
end

local function composter_initialize(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", compost.get_composter_formspec(pos, meta))
	meta:set_string("infotext", "Composter")
	-- how much currently is being processed
	meta:set_float("to_be_processed", 0)
	-- what has already been processed (100 equal one compost)
	meta:set_float("processed", 0)

	local inv = meta:get_inventory()
	inv:set_size(COMPOSTER_INV_INPUT, 9)
	inv:set_size(COMPOSTER_INV_OUTPUT, 4)
end

local function composter_set_full(pos, full)
	if full then
		core.swap_node(pos, {name = "compost:composter_full"})
	else
		core.swap_node(pos, {name = "compost:composter"})
	end
end

local function composter_update_state(pos, meta, inv)
	composter_set_full(
		pos,
		not (
			inv:is_empty(COMPOSTER_INV_INPUT) and
			inv:is_empty(COMPOSTER_INV_OUTPUT)
		)
	)

	meta:set_string("formspec", compost.get_composter_formspec(pos, meta))
end

local function composter_process_work_done(meta, elapsed)
	local last_to_be_processed = meta:get_float("to_be_processed")
	local work = elapsed * compost.COMPOSTER_SPEED

	if work > last_to_be_processed then
		meta:set_float("to_be_processed", 0)
		meta:set_float("processed", meta:get_float("processed") + last_to_be_processed)
	else
		meta:set_float("to_be_processed", last_to_be_processed - work)
		meta:set_float("processed", meta:get_float("processed") + work)
	end
end

local function composter_create_output(meta, inv)
	local processed = meta:get_float("processed")

	while processed >= compost.COMPOST_ITEM_VALUE do
		local item = ItemStack("compost:compost")

		-- FIXME: handle if no room for item
		if inv:room_for_item(COMPOSTER_INV_OUTPUT, item) then
			inv:add_item(COMPOSTER_INV_OUTPUT, item)
		end
		
		processed = processed - compost.COMPOST_ITEM_VALUE
	end

	meta:set_float("processed", processed)
end

local function composter_load_processing_cache(pos, meta)
	local to_be_processed = meta:get_float("to_be_processed")

	-- nothing to be processed
	if to_be_processed < (compost.COMPOSTER_UPDATE_INTERVAL * compost.COMPOSTER_SPEED) then
		-- fetch new item from queue
		local inv = meta:get_inventory()
		if inv:is_empty(COMPOSTER_INV_INPUT) then
			return
		end

		-- search for items
		local filled_cache = false
		for idx, stack in pairs(inv:get_list(COMPOSTER_INV_INPUT)) do
			while not stack:is_empty() and not filled_cache do
				to_be_processed = to_be_processed + compost.get_compost_value(stack:get_name())

				stack:set_count(stack:get_count() - 1)
				inv:set_stack(COMPOSTER_INV_INPUT, idx, stack)

				if to_be_processed >= (compost.COMPOSTER_UPDATE_INTERVAL * compost.COMPOSTER_SPEED) then
					filled_cache = true
				end
			end

			if filled_cache then
				break
			end
		end

		meta:set_float("to_be_processed", to_be_processed)
	end
end

local function composter_handle_timer(pos, elapsed)
	local meta = core.get_meta(pos)
	local inv = meta:get_inventory()

	-- if work was done
	if elapsed > 0 then
		composter_process_work_done(meta, elapsed)
		composter_create_output(meta, inv)
	end

	-- load in new items from queue
	composter_load_processing_cache(pos, meta)

	composter_update_state(pos, meta, inv)

	if meta:get_float("to_be_processed") > 0 then
		local timer = core.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(compost.COMPOSTER_UPDATE_INTERVAL)
		end
	end
end

local function composter_allow_metadata_inventory_put(pos, listname, index, stack, player)
	if listname == COMPOSTER_INV_INPUT and compost.is_compostable_item(stack:get_name()) then
		return stack:get_count()
	end
	return 0
end

local function composter_allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	-- only allow moving inside of lists
	if from_list == to_list then
		return count
	end
	return 0
end

local function composter_on_metadata_inventory_put(pos, listname, index, stack, player)
	core.log("action", player:get_player_name() .. " moves stuff to compost bin at " .. core.pos_to_string(pos))
	local meta = core.get_meta(pos)
	composter_update_state(pos, meta, meta:get_inventory())

	if not core.get_node_timer(pos):is_started() then
		composter_handle_timer(pos, 0)
	end
end

local function composter_on_metadata_inventory_take(pos, listname, index, stack, player)
	core.log("action", player:get_player_name() .. " takes stuff from compost bin at " .. core.pos_to_string(pos))
	local meta = core.get_meta(pos)
	composter_update_state(pos, meta, meta:get_inventory())
end

local function composter_drop_contents(pos, oldnode, oldmetadata, digger)
	local meta = core.get_meta(pos)
	meta:from_table(oldmetadata)
	local inv = meta:get_inventory()

	for _, inventory_name in pairs(COMPOSTER_INVENTORIES) do
		for i = 1, inv:get_size(inventory_name) do
			local stack = inv:get_stack(inventory_name, i)
			if not stack:is_empty() then
				local p = {
					x = pos.x + math.random(0, 5)/5 - 0.5,
					y = pos.y,
					z = pos.z + math.random(0, 5)/5 - 0.5
				}
				core.add_item(p, stack)
			end
		end
	end
end

local composter_common_def = {
	description = "Composter",
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "regular"
	},
	on_construct = composter_initialize,
	allow_metadata_inventory_put = composter_allow_metadata_inventory_put,
	allow_metadata_inventory_move = composter_allow_metadata_inventory_move,
	on_metadata_inventory_put = composter_on_metadata_inventory_put,
	on_metadata_inventory_take = composter_on_metadata_inventory_take,
	on_metadata_inventory_move = composter_on_metadata_inventory_move,
	on_timer = composter_handle_timer,
	after_dig_node = composter_drop_contents
}

do
	local composter_empty_def = table.copy(composter_common_def)
	composter_empty_def.tiles = {
		"compost_composter_top_empty.png",
		"compost_composter_top_empty.png",
		"compost_composter_side.png",
		"compost_composter_side.png",
		"compost_composter_side.png",
		"compost_composter_side.png"
	}
	composter_empty_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			{-0.4375, -0.4375, -0.4375, -0.375, 0.5, -0.375},
			{0.375, -0.4375, 0.375, 0.4375, 0.5, 0.4375},
			{-0.4375, -0.4375, 0.375, -0.375, 0.5, 0.4375},
			{0.375, -0.4375, -0.4375, 0.4375, 0.5, -0.375},
			{-0.5, -0.1875, -0.5, -0.4375, -0.0625, 0.5},
			{-0.5, 0, -0.5, -0.4375, 0.125, 0.5},
			{-0.5, 0.1875, -0.5, -0.4375, 0.3125, 0.5},
			{-0.5, 0.375, -0.5, -0.4375, 0.5, 0.5},
			{-0.5, -0.375, -0.5, -0.4375, -0.25, 0.5},
			{0.4375, -0.1875, -0.5, 0.5, -0.0625, 0.5},
			{0.4375, 0, -0.5, 0.5, 0.125, 0.5},
			{0.4375, 0.1875, -0.5, 0.5, 0.3125, 0.5},
			{0.4375, 0.375, -0.5, 0.5, 0.5, 0.5},
			{0.4375, -0.375, -0.5, 0.5, -0.25, 0.5},
			{-0.5, -0.1875, -0.5, 0.5, -0.0625, -0.4375},
			{-0.5, 0, -0.5, 0.5, 0.125, -0.4375},
			{-0.5, 0.1875, -0.5, 0.5, 0.3125, -0.4375},
			{-0.5, 0.375, -0.5, 0.5, 0.5, -0.4375},
			{-0.5, -0.375, -0.5, 0.5, -0.25, -0.4375},
			{-0.5, -0.1875, 0.4375, 0.5, -0.0625, 0.5},
			{-0.5, 0, 0.4375, 0.5, 0.125, 0.5},
			{-0.5, 0.1875, 0.4375, 0.5, 0.3125, 0.5},
			{-0.5, 0.375, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.375, 0.4375, 0.5, -0.25, 0.5},
		}
	}

	core.register_node("compost:composter", composter_empty_def)
end

do
	local composter_full_def = table.copy(composter_common_def)
	composter_full_def.tiles = {
		"compost_composter_top_full.png",
		"compost_composter_top_empty.png",
		"compost_composter_side.png",
		"compost_composter_side.png",
		"compost_composter_side.png",
		"compost_composter_side.png"
	}
	composter_full_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			{-0.4375, -0.4375, -0.4375, -0.375, 0.5, -0.375},
			{0.375, -0.4375, 0.375, 0.4375, 0.5, 0.4375},
			{-0.4375, -0.4375, 0.375, -0.375, 0.5, 0.4375},
			{0.375, -0.4375, -0.4375, 0.4375, 0.5, -0.375},
			{-0.5, -0.1875, -0.5, -0.4375, -0.0625, 0.5},
			{-0.5, 0, -0.5, -0.4375, 0.125, 0.5},
			{-0.5, 0.1875, -0.5, -0.4375, 0.3125, 0.5},
			{-0.5, 0.375, -0.5, -0.4375, 0.5, 0.5},
			{-0.5, -0.375, -0.5, -0.4375, -0.25, 0.5},
			{0.4375, -0.1875, -0.5, 0.5, -0.0625, 0.5},
			{0.4375, 0, -0.5, 0.5, 0.125, 0.5},
			{0.4375, 0.1875, -0.5, 0.5, 0.3125, 0.5},
			{0.4375, 0.375, -0.5, 0.5, 0.5, 0.5},
			{0.4375, -0.375, -0.5, 0.5, -0.25, 0.5},
			{-0.5, -0.1875, -0.5, 0.5, -0.0625, -0.4375},
			{-0.5, 0, -0.5, 0.5, 0.125, -0.4375},
			{-0.5, 0.1875, -0.5, 0.5, 0.3125, -0.4375},
			{-0.5, 0.375, -0.5, 0.5, 0.5, -0.4375},
			{-0.5, -0.375, -0.5, 0.5, -0.25, -0.4375},
			{-0.5, -0.1875, 0.4375, 0.5, -0.0625, 0.5},
			{-0.5, 0, 0.4375, 0.5, 0.125, 0.5},
			{-0.5, 0.1875, 0.4375, 0.5, 0.3125, 0.5},
			{-0.5, 0.375, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.375, 0.4375, 0.5, -0.25, 0.5},
			{-0.4375, -0.5, -0.4375, 0.4375, 0.3125, 0.4375}
		}
	}
	composter_full_def.groups.not_in_creative_inventory = 1
	composter_full_def.drops = "compost:composter"

	core.register_node("compost:composter_full", composter_full_def)
end

core.register_craft({
	output = "compost:composter",
	recipe = {
		{"group:fence", "", "group:fence"},
		{"group:fence", "", "group:fence"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

core.register_craftitem("compost:compost", {
	description = "Compost",
	inventory_image = "compost_compost.png",
})

core.register_node("compost:garden_soil", {
	description = "Garden Soil",
})

core.register_craft({
	output = "compost:garden_soil",
	recipe = {
		{"", "compost:compost", ""},
		{"compost:compost", "default:dirt", "compost:compost"},
		{"", "compost:compost", ""}
	}
})

compost.register_compostable_item("compost:composter", 58)
compost.register_compostable_item("default:grass_1", 20)
compost.register_compostable_item("default:junglegrass", 23)
compost.register_compostable_item("farming:cotton", 14)
compost.register_compostable_item("farming:string", 14)
compost.register_compostable_item("farming:straw", 76)
compost.register_compostable_item("farming:hoe_wood", 22)

compost.register_compostable_group("flora", 15)
compost.register_compostable_group("plant", 15)
compost.register_compostable_group("grass", 18)
compost.register_compostable_group("flowers", 18)
compost.register_compostable_group("sapling", 23)
compost.register_compostable_group("leaves", 31)
compost.register_compostable_group("stick", 9)
compost.register_compostable_group("wood", 38)
compost.register_compostable_group("tree", 152)
compost.register_compostable_group("seed", 5)
compost.register_compostable_group("food_wheat", 24)
compost.register_compostable_group("food_flour", 27)
compost.register_compostable_group("food_bread", 66)
