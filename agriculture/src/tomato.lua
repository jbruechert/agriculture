--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>
Copyright (C) 2017-2018 MBB
Copyright (C) 2016-2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture.register_crop("tomato", {
	description = "Tomato",
	steps = 8,
	growtime = 1600,
	craft_seed_by_harvest = false,
	seed = {
		name = "agriculture:tomato_seed_with_stick",
		description = "Tomato Seed With Stick",
		inventory_image = "agriculture_tomato_stick_seed.png"
	},
	cond = {
		fertility = {"grassland"}
	},
	plant = {
		visual_scale = 1.5
	},
	harvest = {
		on_use = core.item_eat(4)
	},
	grown_plant_drop = {
		items = {
			{items = {"agriculture:tomato 2"}, rarity = 1},
			{items = {"agriculture:tomato"}, rarity = 3}
		}
	}
})

-- override registered seeds with tomato seed without stick, so this one is dropped by gardens
for i = 0, #agriculture.registered_seeds do
	if agriculture.registered_seeds[i] == "agriculture:tomato_seed_with_stick" then
		agriculture.registered_seeds[i] = "agriculture:tomato_seed"
	end
end

core.register_craftitem("agriculture:tomato_bread", {
	description = "Bread With Tomatos",
	inventory_image = "agriculture_tomato_bread.png",
	on_use = core.item_eat(10),
})

core.register_craftitem("agriculture:tomato_seed", {
	description = "Tomato Seed (need a stick to grow)",
	inventory_image = "agriculture_tomato_seed.png",
})

-- crafting

core.register_craft({
	type = "shapeless",
	output = "agriculture:tomato_bread",
	recipe = {"farming:bread", "agriculture:tomato"}
})

core.register_craft({
	type = "shapeless",
	output = "agriculture:tomato_seed",
	recipe = {"agriculture:tomato"}
})

core.register_craft({
	type = "shapeless",
	output = "agriculture:tomato_seed_with_stick",
	recipe = {"agriculture:tomato_seed", "default:stick"}
})
