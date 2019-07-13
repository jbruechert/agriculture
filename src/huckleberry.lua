--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>
Copyright (C) 2017-2018 MBB
Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture.register_crop("huckleberry", {
	description = "Huckleberry",
	steps = 5,
	growtime = 2600,
	step_after_harvest = 3,
	cond = {
		fertility = {"grassland"}
	},
	craft_seed_by_harvest = true,
	harvest = {
		on_use = core.item_eat(1),
	},
	grown_plant_drop = {
		items = {
			{items = {"agriculture:huckleberry 2"}, rarity = 1},
			{items = {"agriculture:huckleberry"}, rarity = 3}
		}
	}
})

-- Change drawtype of the plants
core.override_item("agriculture:huckleberry_2", {
	drawtype = "mesh",
	mesh = "agriculture_huckleberry_bush_2.obj",
})

for i = 3, 5 do
	core.override_item("agriculture:huckleberry_"..i, {
		drawtype = "mesh",
		mesh = "agriculture_huckleberry_bush.obj",
	})
end

core.register_craftitem("agriculture:huckleberry_pie", {
	description = "Huckleberry Pie",
	inventory_image = "agriculture_huckleberry_pie.png",
	on_use = core.item_eat(20),
})

core.register_craftitem("agriculture:huckleberry_pie_dough", {
	description = "Huckleberry Pie Dough ",
	inventory_image = "agriculture_huckleberry_pie_dough.png",
	on_use = core.item_eat(20),
})

core.register_craft({
	type = "shapeless",
	output = "agriculture:huckleberry_pie_dough",
	recipe = {"agriculture:huckleberry", "farming:flour", "agriculture:sugar"}
})

core.register_craft({
	type = "cooking",
	cooktime = 18,
	output = "agriculture:huckleberry_pie",
	recipe = "agriculture:huckleberry_pie_dough"
})
