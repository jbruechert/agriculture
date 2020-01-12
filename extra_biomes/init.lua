--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2015-2018 Jonah Brüchert <jbb@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

extra_biomes = {}

modpath = core.get_modpath("extra_biomes")

dofile(modpath .. "/src/bamboo.lua")
dofile(modpath .. "/src/fern.lua")

