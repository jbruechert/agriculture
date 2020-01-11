for index, color in ipairs({"brown", "red"}) do
    core.override_item("flowers:mushroom_"..color, {
        tiles = {"flowers_mushroom_" .. color .. "_top.png", "flowers_mushroom_" .. color .. "_top.png", "flowers_mushroom_" .. color .. ".png"},
        drawtype = "nodebox",
        node_box = {
            type = "fixed",
            fixed = {
                {-1/16, -8/16, -1/16, 1/16, -6/16, 1/16},
                {-3/16, -6/16, -3/16, 3/16, -5/16, 3/16},
                {-4/16, -5/16, -4/16, 4/16, -4/16, 4/16},
                {-3/16, -4/16, -3/16, 3/16, -3/16, 3/16},
                {-2/16, -3/16, -2/16, 2/16, -2/16, 2/16},
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.3}
        }
    })
end
