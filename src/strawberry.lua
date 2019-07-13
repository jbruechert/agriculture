--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>
Copyright (C) 2017-2018 MBB
Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture.register_crop("strawberry", {
	description = "Strawberry",
	steps = 4,
	growtime = 1100,
	cond = {
		fertility = {"grassland"}
	},
	craft_seed_by_harvest = true,
	harvest = {
		on_use = core.item_eat(1),
	}
})

core.register_craftitem("agriculture:strawberry_cake", {
	description = "Strawberry Cake",
	inventory_image = "agriculture_strawberry_cake.png",
	on_use = core.item_eat(20),
})

core.register_craftitem("agriculture:strawberry_cake_dough", {
	description = "Strawberry Cake Dough",
	inventory_image = "agriculture_strawberry_cake_dough.png",
})

-- crafting
core.register_craft({
	type = "shapeless",
	output = "agriculture:strawberry_cake_dough",
	recipe = {"agriculture:strawberry", "farming:flour", "agriculture:sugar"}
})


core.register_craft({
	type = "cooking",
	cooktime = 18,
	output = "agriculture:strawberry_cake",
	recipe = "agriculture:strawberry_cake_dough"
})
