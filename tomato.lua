
--tomato and tomato stick

farming.register_plant("agriculture:tomato", {
	description = "Tomato Stick Wirth Seeds",
	inventory_image = "agriculture_tomato_stick_seed.png",
	steps = 8,
	minlight = 12,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
})

minetest.register_craftitem("agriculture:tomato_bread", {
	description = "Bread With Tomatos",
	inventory_image = "agriculture_tomato_bread.png",
        on_use = minetest.item_eat(10),
})

minetest.register_craftitem("agriculture:tomato_seed", {
	description = "Tomato Seed (need a stick to grow)",
	inventory_image = "agriculture_tomato_seed.png",
        on_use = minetest.item_eat(10),
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:tomato_bread",
	recipe = {"farming:bread", "agriculture:tomato"}
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:tomato_seed",
	recipe = {"agriculture:tomato"}
})

minetest.register_craft({
	type = "shapeless",
	output = "agriculture:seed_tomato",
	recipe = {"agriculture:tomato_seed", "default:stick"}
})


	
for i = 1 , 8 do		
	minetest.override_item("agriculture:tomato_"..i, {
                drawtype = "plantlike",
		visual_scale = 1.4 ,
	})
end

-- change the drop of the already big grown tomato

minetest.override_item("agriculture:tomato_8", {
     drawtype = "plantlike",
     visual_scale = 1.5 ,
     drop = "agriculture:tomato 3"   
})

--change the drawtype of the seed with stick

minetest.override_item("agriculture:seed_tomato", {
     drawtype = "plantlike",
     visual_scale = 1.5 ,  
})