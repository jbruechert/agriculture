farming.register_plant("agriculture:huckleberry", {
	description = "Huckleberry Seeds",
	inventory_image = "agriculture_huckleberry_seeds.png",
	steps = 5,
	minlight = 12,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
})

table.insert(agriculture.registered_seeds, "agriculture:seed_huckleberry")

-- Change Drawtype of the plants
for i = 3 , 5 do		
	minetest.override_item("agriculture:huckleberry_"..i, {
		drawtype = "mesh",
		mesh = "agriculture_huckleberry_bush.obj",
	})
end


minetest.override_item("agriculture:huckleberry_2", {
	drawtype = "mesh",
	mesh = "agriculture_huckleberry_bush_2.obj",
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:seed_huckleberry",
	recipe = {"agriculture:huckleberry"}
})

minetest.register_craftitem("agriculture:huckleberry_pie", {
	description = "Huckleberry Pie",
	inventory_image = "agriculture_huckleberry_pie.png",
	on_use = minetest.item_eat(20),
})

minetest.register_craftitem("agriculture:huckleberry_pie_dough", {
	description = "Huckleberry Pie Dough ",
	inventory_image = "agriculture_huckleberry_pie_dough.png",
	on_use = minetest.item_eat(20),
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:huckleberry_pie_dough",
	recipe = {"agriculture:huckleberry", "farming:flour", "agriculture:sugar"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 18,
	output = "agriculture:huckleberry_pie",
	recipe = "agriculture:huckleberry_pie_dough"
})


-- Override drop
minetest.override_item("agriculture:huckleberry_5", {
	drawtype = "mesh",
	mesh = "agriculture_huckleberry_bush.obj",
	drop = "agriculture:huckleberry 3"
})

-- make huckleberry eatable
minetest.override_item("agriculture:huckleberry", {
	on_use = minetest.item_eat(1),
})
