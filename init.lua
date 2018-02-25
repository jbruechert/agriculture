dofile(minetest.get_modpath("agriculture") .. "/carrot.lua")
dofile(minetest.get_modpath("agriculture") .. "/sugar_beet.lua")
dofile(minetest.get_modpath("agriculture") .. "/strawberry.lua")
dofile(minetest.get_modpath("agriculture") .. "/corn.lua")
dofile(minetest.get_modpath("agriculture") .. "/tomato.lua")
dofile(minetest.get_modpath("agriculture") .. "/huckleberry.lua")


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


-- Modifyiing drops

for i = 1, 5 do
	minetest.override_item("default:grass_"..i, {
		drop = {
			max_items = 1,
			items = {
				{items = {"farming:seed_wheat"}, rarity = 5},
				{items = {"default:grass_1"}}
			}
		}
	})
end

for i = 1, 5 do
	minetest.override_item("default:dry_grass_"..i, {
		drop = {
			max_items = 1,
			items = {
				{items = {"agriculture:seed_sugar_beet"}, rarity = 5},
				{items = {"default:dry_grass_1"}}
			}
		}
	})
end

minetest.override_item("default:junglegrass", {
	drop = {
		max_items = 1,
		items = {
			{items = {"agriculture:seed_carrot"}, rarity = 5},
			{items = {"default:dry_grass_1"}}
		}
	}
})


minetest.override_item("default:papyrus", {
	drop = {
		max_items = 1,
		items = {
			{items = {"agriculture:seed_corn"}, rarity = 5},
			{items = {"default:papyrus"}}
		}
	}
})


minetest.override_item("default:dirt_with_grass", {
	drop = {
		max_items = 1,
		items = {
			{items = {"agriculture:tomato_seed"}, rarity = 8, "default:dirt"},
			{items = {"agriculture:seed_sugar_beet"}, rarity = 12, "default:dirt"},
			{items = {"default:dirt"}},
		}
	}
})

minetest.override_item("default:bush_leaves", {
	drop = {
		max_items = 1,
		items = {
			{items = {"agriculture:seed_huckleberry"}, rarity = 8, "default:bush_leaves"},
			{items = {"agriculture:seed_huckleberry"}, rarity = 12, "default:bush_leaves"},
			{items = {"default:bush_leaves"}},
		}
	}
})

minetest.override_item("default:dry_shrub", {
	drop = {
		max_items = 1,
		items = {
			{items = {"agriculture:seed_strawberry"}, rarity = 8},
			{items = {"default:dry_shrub"}},
		}
	}
})
