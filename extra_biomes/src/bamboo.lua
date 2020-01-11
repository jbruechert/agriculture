--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2016-2020 Jonah Brüchert <jbb@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

function extra_biomes.grow_bamboo(pos, node)
    pos.y = pos.y - 1
    local name = core.get_node(pos).name
    if name ~= "default:dirt_with_grass" and name ~= "default:dirt" then
        return
    end
    pos.y = pos.y + 1
    local height = 0
    while node.name == "extra_biomes:bamboo" and height < 15 do
        height = height + 1
        pos.y = pos.y + 1
        node = core.get_node(pos)
    end
    if height > 10 or node.name ~= "air" then
        core.set_node(pos, {name = "extra_biomes:bamboo"})
        core.set_node({x = pos.x + 1, y = pos.y, z = pos.z}, {name = "extra_biomes:bamboo_leaves"})
        core.set_node({x = pos.x, y = pos.y, z = pos.z + 1}, {name = "extra_biomes:bamboo_leaves"})
        core.set_node({x = pos.x - 1, y = pos.y, z = pos.z}, {name = "extra_biomes:bamboo_leaves"})
        core.set_node({x = pos.x, y = pos.y, z = pos.z - 1}, {name = "extra_biomes:bamboo_leaves"})
    end
    if height == 15 or node.name ~= "air" then
        core.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "extra_biomes:bamboo_leaves"})
    end
        core.set_node(pos, {name = "extra_biomes:bamboo"})
    return true
end

local function my_register_stair_and_slab(subname, recipeitem, groups, images,
                desc_stair, desc_slab, sounds, worldaligntex)
        stairs.register_stair(subname, recipeitem, groups, images, desc_stair,
                sounds, worldaligntex)
        stairs.register_stair_inner(subname, recipeitem, groups, images, "",
                sounds, worldaligntex, "Inner " .. desc_stair)
        stairs.register_stair_outer(subname, recipeitem, groups, images, "",
                sounds, worldaligntex, "Outer " .. desc_stair)
        stairs.register_slab(subname, recipeitem, groups, images, desc_slab,
                sounds, worldaligntex)
end

core.register_abm({
    nodenames = {"extra_biomes:bamboo"},
    neighbors = {"default:dirt", "default:dirt_with_grass", "default:sand"},
    interval = 30, -- 50
    chance = 8,  -- 20
    action = extra_biomes.grow_bamboo
})

core.register_biome({
    name = "bamboo_forest",
    --node_dust = "",
    node_top = "default:dirt_with_grass",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 5,
    node_stone = "default:stone",
    --node_water_top = "",
    --depth_water_top = ,
    --node_water = "",
    --node_river_water = "",
    y_min = 5,
    y_max = 31000,
    heat_point = 75,
    humidity_point = 80,
})

core.register_decoration({
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    fill_ratio = 0.15,
    biomes = {"bamboo_forest"},
    y_min = 0,
    y_max = 31000,
    schematic = modpath.. "/schematics/bamboo.mts",
})

core.register_node("extra_biomes:bamboo", {
    description = "Bamboo",
    drawtype = "nodebox",
    tiles = {"extra_biomes_bamboo_top.png", "extra_biomes_bamboo_top.png", "extra_biomes_bamboo.png"},
    inventory_image = "extra_biomes_bamboo.png",
    wield_image = "extra_biomes_bamboo.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = true,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.5, -0.5, -0.25, 0.5, 0.5},
            {-0.5, -0.5, -0.25, 0.5, 0.5, -0.25},
            {0.25, -0.5, -0.5, 0.25, 0.5, 0.5},
            {-0.5, -0.5, 0.25, 0.5, 0.5, 0.25},
            {-0.25, 0.5, -0.25, 0.25, 0.5, 0.25},
            {-0.25, -0.5, -0.25, 0.25, -0.5, 0.25},
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, stick = 1, tree = 1},
    sounds = default.node_sound_wood_defaults(),
    after_dig_node = function(pos, node, metadata, digger)
        default.dig_up(pos, node, digger)
    end,
})

core.register_node("extra_biomes:bamboo_leaves", {
    description = "Bamboo Leaves",
    tiles = {"extra_biomes_bamboo_leaves.png"},
    paramtype = "light",
    drawtype = "plantlike",
    paramtype2 = "facedir",
    visual_scale = 1.2,
    groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, fuel = 2}	
})

core.register_decoration({
    deco_type = "simple",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
        offset = offset,
        scale = scale,
        spread = {x = 250, y = 250, z = 250},
        seed = 329,
        octaves = 3,
        persist = 0.6
    },
    biomes = {"bamboo_forest"},
    y_min = 1,
    y_max = 31000,
    decoration = "default:grass_5"
})

core.register_node("extra_biomes:bamboo_wood", {
    description = "Bamboo Wood",
    tiles = {{name="extra_biomes_bamboo_wood.png", align_style="world", scale=2}},
    inventory_image = minetest.inventorycube("extra_biomes_bamboo_wood_inventory.png"),
    paramtype2 = "facedir",
    place_param2 = 0,
    is_ground_content = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
    output = "extra_biomes:bamboo_wood",
    recipe = {
        {"extra_biomes:bamboo", "extra_biomes:bamboo", "extra_biomes:bamboo"},
        {"extra_biomes:bamboo", "extra_biomes:bamboo", "extra_biomes:bamboo"},
        {"extra_biomes:bamboo", "extra_biomes:bamboo", "extra_biomes:bamboo"},
    }
})

-- subname, recipeitem, groups, images, desc_stair, desc_slab, sounds, worldaligntex
my_register_stair_and_slab(
    "bamboo_wood",
    "extra_biomes:bamboo_wood",
    {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    {{name="extra_biomes_bamboo_wood.png", align_style="world", scale=2}},
    "Bamboo Wood Stair",
    "Bamboo Wood Slab",
    default.node_sound_stone_defaults(),
    true
)
