farming.register_plant("agriculture:corn", {
	description = "Corn Seeds",
	inventory_image = "agriculture_corn_seed.png",
	steps = 8,
	minlight = 12,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
})

table.insert(agriculture.registered_seeds, "agriculture:seed_corn")

minetest.register_craftitem("agriculture:corn_bread", {
	description = "Corn Bread",
	inventory_image = "agriculture_corn_bread.png",
	on_use = minetest.item_eat(20),
})

minetest.register_craftitem("agriculture:corn_bread_dough", {
	description = "Corn Bread Dough",
	inventory_image = "agriculture_corn_bread_dough.png",
})

-- crafting

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:seed_corn",
	recipe = {"agriculture:corn"}
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:corn_bread_dough",
	recipe = {"agriculture:corn", "farming:flour", "agriculture:salt"}
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:corn_bread_dough",
	recipe = {"agriculture:seed_corn", "farming:flour", "agriculture:salt"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 18,
	output = "agriculture:corn_bread",
	recipe = "agriculture:corn_bread_dough"
})

minetest.register_craftitem("agriculture:corn_baken", {
	description = "Baken Corn",
	inventory_image = "agriculture_corn_baken.png",
	on_use = minetest.item_eat(5),
})

minetest.register_craft({
	type = "cooking",
	cooktime = 14,
	output = "agriculture:corn_baken",
	recipe = "agriculture:corn"
})

-- Change visual scale of the corn plants
for i = 1 , 8 do		
	minetest.override_item("agriculture:corn_"..i, {
		drawtype = "plantlike",
		visual_scale = 1.5 ,
	})
end

-- Override drop
minetest.override_item("agriculture:corn_8", {
	drawtype = "plantlike",
	visual_scale = 1.5 ,
	drop = "agriculture:corn 3"
})
