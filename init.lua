agriculture = {}
agriculture.registered_seeds = {}

local modpath = core.get_modpath("agriculture")

dofile(modpath .. "/src/carrot.lua")
dofile(modpath .. "/src/sugar_beet.lua")
dofile(modpath .. "/src/strawberry.lua")
dofile(modpath .. "/src/corn.lua")
dofile(modpath .. "/src/tomato.lua")
dofile(modpath .. "/src/huckleberry.lua")
-- gardens are loaded after all plants have been registered
dofile(modpath .. "/src/gardens.lua")

-- salt

minetest.register_craft( {
	type = "cooking",
	cooktime = 5,
	output = "agriculture:salt 6",
	recipe = "bucket:bucket_water",
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	},
})

minetest.register_craftitem("agriculture:salt", {
	description = "Salt",
	inventory_image = "agriculture_salt.png",
})
