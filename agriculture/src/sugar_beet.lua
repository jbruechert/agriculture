--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>
Copyright (C) 2017-2018 MBB
Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture.register_crop("sugar_beet", {
	description = "Sugar Beet",
	steps = 5,
	growtime = 1250,
	cond = {
		fertility = {"grassland"}
	},
	craft_seed_by_harvest = true,
})

core.register_craftitem("agriculture:sugar", {
	description = "Sugar",
	inventory_image = "agriculture_sugar.png",
})

-- crafting
core.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "agriculture:sugar",
	recipe = "agriculture:sugar_beet"
})
