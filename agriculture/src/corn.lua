--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>
Copyright (C) 2017-2018 MBB
Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture.register_crop("corn", {
	description = "Corn",
	steps = 8,
	growtime = 1500,
	cond = {
		fertility = {"grassland"}
	},
    plant = {
    paramtype2 = "meshoptions",
    place_param2 = 3,},
	craft_seed_by_harvest = true,
	grown_plant_drop = {
		items = {
			{items = {"agriculture:corn 2"}, rarity = 1},
			{items = {"agriculture:corn"}, rarity = 3}
		}
	}
})

--override corn
core.override_item("agriculture:corn_8", {
	drawtype = "mesh",
	mesh = "agriculture_corn_8.obj",
    waving = 0

})

core.override_item("agriculture:corn_7", {
	drawtype = "mesh",
	mesh = "agriculture_corn_8.obj",
    waving = 0

})

core.override_item("agriculture:corn_6", {
	drawtype = "mesh",
	mesh = "agriculture_corn_6.obj",
    waving = 0

})

core.override_item("agriculture:corn_5", {
    visual_scale = 2

})

core.override_item("agriculture:corn_4", {
    visual_scale = 2

})
    
core.override_item("agriculture:corn_3", {
    visual_scale = 2

})



core.register_craftitem("agriculture:corn_bread", {
	description = "Corn Bread",
	inventory_image = "agriculture_corn_bread.png",
	on_use = core.item_eat(20),
})

core.register_craftitem("agriculture:corn_bread_dough", {
	description = "Corn Bread Dough",
	inventory_image = "agriculture_corn_bread_dough.png",
})

-- crafting

core.register_craft({
	type = "shapeless",
	output = "agriculture:corn_bread_dough",
	recipe = {"agriculture:corn", "farming:flour", "agriculture:salt"}
})

core.register_craft({
	type = "shapeless",
	output = "agriculture:corn_bread_dough",
	recipe = {"agriculture:seed_corn", "farming:flour", "agriculture:salt"}
})

core.register_craft({
	type = "cooking",
	cooktime = 18,
	output = "agriculture:corn_bread",
	recipe = "agriculture:corn_bread_dough"
})

core.register_craftitem("agriculture:corn_baken", {
	description = "Baken Corn",
	inventory_image = "agriculture_corn_baken.png",
	on_use = core.item_eat(5),
})

core.register_craft({
	type = "cooking",
	cooktime = 14,
	output = "agriculture:corn_baken",
	recipe = "agriculture:corn"
})
