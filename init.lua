--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>
Copyright (C) 2017-2018 MBB
Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

agriculture = {}
-- increase for longer growing
agriculture.GROW_TIME_FACTOR = 1.0

local modpath = core.get_modpath("agriculture")

-- crop registration api
dofile(modpath .. "/src/api_crops.lua")
-- crop registrations
dofile(modpath .. "/src/carrot.lua")
dofile(modpath .. "/src/sugar_beet.lua")
dofile(modpath .. "/src/strawberry.lua")
dofile(modpath .. "/src/corn.lua")
dofile(modpath .. "/src/tomato.lua")
dofile(modpath .. "/src/huckleberry.lua")
-- gardens are loaded after all plants have been registered
dofile(modpath .. "/src/gardens.lua")
-- legacy compatibility
dofile(modpath .. "/src/legacy.lua")

-- salt

core.register_craft( {
	type = "cooking",
	cooktime = 5,
	output = "agriculture:salt 6",
	recipe = "bucket:bucket_water",
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	},
})

core.register_craftitem("agriculture:salt", {
	description = "Salt",
	inventory_image = "agriculture_salt.png",
})
