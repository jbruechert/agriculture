farming.register_plant("agriculture:sugar_beet", {
	description = "Sugar Beet Seed",
	inventory_image = "agriculture_sugar_beet_seed.png",
	steps = 5,
	minlight = 10,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
})

table.insert(agriculture.registered_seeds, "agriculture:seed_sugar_beet")

minetest.register_craftitem("agriculture:sugar", {
	description = "Sugar",
	inventory_image = "agriculture_sugar.png",
})

-- crafting

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "agriculture:sugar",
	recipe = "agriculture:sugar_beet"
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:seed_sugar_beet",
	recipe = {"agriculture:sugar_beet"}
})

-- Override drop
minetest.override_item("agriculture:sugar_beet_5", {
    drop = "agriculture:sugar_beet 2"
})
