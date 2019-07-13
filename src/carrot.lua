--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>
Copyright (C) 2017-2018 MBB
Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture.register_crop("carrot", {
	description = "Carrot",
	steps = 4,
	growtime = 1050,
	cond = {
		fertility = {"grassland"},
	},
	harvest = {
		on_use = core.item_eat(1),
	},
	craft_seed_by_harvest = true
})

minetest.register_craftitem("agriculture:carrot_cake", {
	description = "Carrot Cake",
	inventory_image = "agriculture_carrot_cake.png",
	on_use = minetest.item_eat(20),
})

minetest.register_craftitem("agriculture:carrot_cake_dough", {
	description = "Carrot Cake Dough",
	inventory_image = "agriculture_carrot_cake_dough.png",
})

-- crafting

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
