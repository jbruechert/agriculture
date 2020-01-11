--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2020 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture.register_crop("lettuce", {
	description = "Lettuce",
	steps = 7,
	growtime = 760,
	has_seed = false,
	cond = {
		fertility = {"grassland"},
	},
	harvest = {
		on_use = core.item_eat(1)
	}
})
