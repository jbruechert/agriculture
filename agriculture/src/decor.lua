 

core.register_node("agriculture:scarecrow", {
    description = "Scarecrow",
    drawtype = "mesh",
    tiles = {"agriculture_scarecrow.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    walkable = true,
    mesh = "agriculture_scarecrow.obj",
    groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, stick = 1, tree = 1},
    sounds = default.node_sound_wood_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
    }
})

minetest.register_craft({
    output = "agriculture:scarecrow",
    recipe = {
        {"", "wool:blue", "default:steel_ingot"},
        {"default:stick", "farming:straw", "default:stick"},
        {"", "farming:straw", "default:steel_ingot"},
    }
})
