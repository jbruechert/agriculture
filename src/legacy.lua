--[[
This file is part of the Minetest Mod Agriculture.

Copyright (C) 2019 Linus Jahn <lnj@kaidan.im>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
]]

core.register_alias("agriculture:seed_carrot", "agriculture:carrot_seed")
core.register_lbm({
	name = "agriculture:seed_carrot_replacement",
	nodenames = {"agriculture:seed_carrot"},
	action = function(pos, node)
		core.set_node(pos, {name = "agriculture:carrot_1"})
	end
})

core.register_alias("agriculture:seed_corn", "agriculture:corn_seed")
core.register_lbm({
	name = "agriculture:seed_corn_replacement",
	nodenames = {"agriculture:seed_corn"},
	action = function(pos, node)
		core.set_node(pos, {name = "agriculture:corn_1"})
	end
})

core.register_alias("agriculture:seed_huckleberry", "agriculture:huckleberry_seed")
core.register_lbm({
	name = "agriculture:huckleberry_seed_replacement",
	nodenames = {"agriculture:seed_huckleberry"},
	action = function(pos, node)
		core.set_node(pos, {name = "agriculture:huckleberry_1"})
	end
})

core.register_alias("agriculture:seed_strawberry", "agriculture:strawberry_seed")
core.register_lbm({
	name = "agriculture:strawberry_seed_replacement",
	nodenames = {"agriculture:seed_strawberry"},
	action = function(pos, node)
		core.set_node(pos, {name = "agriculture:strawberry_1"})
	end
})

core.register_alias("agriculture:seed_sugar_beet", "agriculture:sugar_beet_seed")
core.register_lbm({
	name = "agriculture:sugar_beet_seed_replacement",
	nodenames = {"agriculture:seed_sugar_beet"},
	action = function(pos, node)
		core.set_node(pos, {name = "agriculture:sugar_beet_1"})
	end
})

core.register_alias("agriculture:seed_tomato", "agriculture:tomato_seed_with_stick")
core.register_lbm({
	name = "agriculture:tomato_seed_replacement",
	nodenames = {"agriculture:seed_tomato"},
	action = function(pos, node)
		core.set_node(pos, {name = "agriculture:tomato_1"})
	end
})
