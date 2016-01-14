
--strawberrys

farming.register_plant("agriculture:strawberry", {
	description = "Strawberry Seeds",
	inventory_image = "agriculture_strawberry_seed.png",
	steps = 4,
	minlight = 11,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
})

minetest.register_craftitem("agriculture:strawberry_cake", {
	description = "Strawberry Cake",
	inventory_image = "agriculture_strawberry_cake.png",
        on_use = minetest.item_eat(20),
})

minetest.register_craftitem("agriculture:strawberry_cake_dough", {
	description = "Strawberry Cake Dough",
	inventory_image = "agriculture_strawberry_cake_dough.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:seed_strawberry",
	recipe = {"agriculture:strawberry"}
})


minetest.register_craft({
	type = "shapeless",
	output = "agriculture:strawberry_cake_dough",
	recipe = {"agriculture:strawberry", "farming:flour", "agriculture:sugar"}
})


minetest.register_craft({
	type = "cooking",
	cooktime = 18,
	output = "agriculture:strawberry_cake",
	recipe = "agriculture:strawberry_cake_dough"
})





minetest.override_item("agriculture:strawberry_4", {
    drop = "agriculture:strawberry 2"
})


minetest.override_item("agriculture:strawberry", {
    on_use = minetest.item_eat(1),
})
