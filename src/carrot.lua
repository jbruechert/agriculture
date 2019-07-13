farming.register_plant("agriculture:carrot", {
	description = "Carrot Seed",
	inventory_image = "agriculture_carrot_seed.png",
	steps = 4,
	minlight = 10,
	fertility = {"grassland"},
})

table.insert(agriculture.registered_seeds, "agriculture:seed_carrot")

minetest.register_craftitem("agriculture:carrot_cake", {
	description = "Carrot Cake",
	inventory_image = "agriculture_carrot_cake.png",
	on_use = minetest.item_eat(20),
})

minetest.register_craftitem("agriculture:carrot_cake_dough", {
	description = "carrot Cake dough",
	inventory_image = "agriculture_carrot_cake_dough.png",
})

-- crafting

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:seed_carrot",
	recipe = {"agriculture:carrot"}
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:carrot_cake_dough",
	recipe = {"agriculture:carrot", "farming:flour", "agriculture:sugar"}
})


minetest.register_craft({
	type = "cooking",
	cooktime = 18,
	output = "agriculture:carrot_cake",
	recipe = "agriculture:carrot_cake_dough"
})

-- make carrot eatable
minetest.override_item("agriculture:carrot", {
    on_use = minetest.item_eat(1),
})

-- Override drop
minetest.override_item("agriculture:carrot_4", {
    drop = "agriculture:carrot 2"
})
