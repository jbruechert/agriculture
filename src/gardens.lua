-- mods/farming/gardens.lua
-- ========================
-- See README.txt for licensing and other information.

--
-- API
--

local function drop_rnd(pos, item)
	core.add_item({x = pos.x + math.random(-25, 25)/100, y = pos.y,
		z = pos.z + math.random(-25, 25)/100}, item)
end

function farming.register_garden(name, def)
	local items = def.items
	local number_of_drops = def.number_of_drops or 2

	def.description = def.description or "Garden"
	def.paramtype = "light"
	def.drawtype = "plantlike"
	def.tiles = def.tiles or {def.texture}
	def.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		core.remove_node(pos)
		core.add_item(pos, name)
	end
	def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		for i = 1, number_of_drops + math.random(-1, 1) do
			local item = items[math.random(1, #items)]
			drop_rnd(pos, item)
		end
	end
	def.sunlight_propagates = true
	def.walkable = false
	def.groups = def.groups or {}
	def.groups.garden = 1
	def.groups.attached_node = 1
	def.groups.snappy = 3
	def.groups.flora = 1
	def.drop = ""

	-- clean up
	def.items = nil
	def.number_of_drops = nil

	core.register_node(name, def)
end

--
-- Gardens
--

farming.register_garden("farming:garden", {
	items = farming.registered_seeds,
	texture = "farming_garden.png",
})

--
-- MapGen
--

local function register_garden_decoration(name, biomes, fill_ratio)
	core.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		fill_ratio = fill_ratio,
		biomes = biomes,
		y_min = 3,
		y_max = 80,
		decoration = name,
	})
end

if core.get_mapgen_params().mgname ~= "v6" then
	register_garden_decoration("farming:garden", {"stone_grassland", "sandstone_grassland"}, 0.00008)
	register_garden_decoration("farming:garden", {"maple_forest", "red_maple_forest", "mixed_maple_forest",
		"cherry_tree_forest", "deciduous_forest"}, 0.00004)
else
	register_garden_decoration("farming:garden", nil, 0.00008)
end
