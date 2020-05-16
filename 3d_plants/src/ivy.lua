
core.register_node("3d_plants:ivy", {
    description = "ivy",
    drawtype = "mesh",
    tiles = {"3d_plants_ivy.png"},
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    walkable = false,
    mesh = "3d_plants_ivy.obj",
    groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, stick = 1, tree = 1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5}
    }
})


minetest.register_craft({
    output = "3d_plants:ivy",
    recipe = {
        {"group:leaves", "default:stick"},
        {"default:stick", "group:leaves"},
        {"group:leaves", "default:stick"},
    }
})
