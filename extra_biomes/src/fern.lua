 
minetest.override_item("default:fern_1", {
        waving = 1,
        tiles = {"extra_biomes_fern_1.png"},
        inventory_image = "extra_biomes_fern_1.png",
        wield_image = "extra_biomes_fern_1.png",
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 4,
        sunlight_propagates = true,
        groups = {snappy = 3, flammable = 3, attached_node = 1, compostable = 20},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
                type = "fixed",
                fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16}
        },
})

minetest.override_item("default:fern_2", {
        visual_scale = 1,
        waving = 1,
        tiles = {"extra_biomes_fern_2.png"},
        inventory_image = "extra_biomes_fern_2.png",
        wield_image = "extra_biomes_fern_2.png",
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 4,
        sunlight_propagates = true,
        groups = {snappy = 3, flammable = 3, attached_node = 1, compostable = 20, not_in_creative_inventory = 1},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
                type = "fixed",
                fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16},
        },
})


minetest.override_item("default:fern_3", {
        waving = 1,
        tiles = {"extra_biomes_fern_3.png"},
        inventory_image = "extra_biomes_fern_3.png",
        wield_image = "extra_biomes_fern_3.png",
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 4,
        sunlight_propagates = true,
        groups = {snappy = 3, flammable = 3, attached_node = 1, compostable = 20, not_in_creative_inventory = 1},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
                type = "fixed",
                fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16}
        },
})

-- generate fern in bamboo forrests

core.register_decoration({
    deco_type = "simple",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
        spread = {x = 250, y = 250, z = 250},
        seed = 356,
        octaves = 3,
        persist = 1
    },
    biomes = {"bamboo_forest"},
    y_min = 1,
    y_max = 31000,
    param2 = 4,
    decoration = "default:fern_1"
})

core.register_decoration({
    deco_type = "simple",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
        spread = {x = 250, y = 250, z = 250},
        seed = 235,
        octaves = 3,
        persist = 1
    },
    biomes = {"bamboo_forest"},
    y_min = 1,
    y_max = 31000,
    param2 = 4,
    decoration = "default:fern_2"
})

core.register_decoration({
    deco_type = "simple",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
        spread = {x = 250, y = 250, z = 250},
        seed = 787,
        octaves = 3,
        persist = 1
    },
    biomes = {"bamboo_forest"},
    y_min = 1,
    y_max = 31000,
    param2 = 4,
    decoration = "default:fern_3"
})
