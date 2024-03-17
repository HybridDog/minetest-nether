-- Nether Mod (based on Nyanland by Jeija, Catapult by XYZ, and Livehouse by neko259)
-- lkjoel (main developer, code, ideas, textures)
-- == CONTRIBUTERS ==
-- jordan4ibanez (code, ideas, textures)
-- Gilli (code, ideas, textures, mainly for the Glowstone)
-- Death Dealer (code, ideas, textures)
-- LolManKuba (ideas, textures)
-- IPushButton2653 (ideas, textures)
-- Menche (textures)
-- sdzen (ideas)
-- godkiller447 (ideas)
-- If I didn't list you, please let me know!

local load_time_start = minetest.get_us_time()

if not rawget(_G, "nether") then
	nether = {}
end

-- similar to INIT
nether.env_type = "ssm" -- server-side-modding

nether.path = minetest.get_modpath("nether")
local path = nether.path

dofile(path .. "/common.lua")

dofile(path .. "/items.lua")
--dofile(path .. "/furnace.lua")
dofile(path .. "/pearl.lua")

dofile(path .. "/grow_structures.lua")

if minetest.register_mapgen_script then
	minetest.log("info", "nether mapgen running in mapgen env")

	minetest.register_mapgen_script(path .. "/init_emerge.lua")

	minetest.set_gen_notify("custom", nil,
			{"nether:please_grow_trees", "nether:please_fix_light"})

	minetest.register_on_generated(function(minp, maxp, blockseed)
		local t0 = minetest.get_us_time()

		local gennotify = minetest.get_mapgen_object("gennotify")

		-- forest trees
		local trees_hashed = gennotify.custom["nether:please_grow_trees"] or {}
		for i = 1, #trees_hashed do
			local pos = minetest.get_position_from_hash(trees_hashed[i])
			nether.grow_tree(pos, true)
		end

		if #trees_hashed > 0 then
			nether:inform(#trees_hashed .. " trees set", 2, t0)
		end

		-- fix light
		local fixlight_area = gennotify.custom["nether:please_fix_light"]
		if fixlight_area then
			t0 = minetest.get_us_time()
			minetest.fix_light(fixlight_area[1], fixlight_area[2])
			nether:inform("light fixed", 2, t0)
		end
	end)

else
	minetest.log("info", "nether mapgen running in main env")
	dofile(path .. "/mapgen.lua")
end

--abms

minetest.register_abm({
	nodenames = {"nether:sapling"},
	neighbors = {"nether:blood_top"},
	interval = 20,
	chance = 8,
	action = function(pos)
		local under = {x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.get_node_light(pos) < 4
		and minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "air"
		and minetest.get_node(under).name == "nether:blood_top" then
			nether.grow_netherstructure(under)
		end
	end
})

minetest.register_abm({
	nodenames = {"nether:tree_sapling"},
	neighbors = {"group:nether_dirt"},
	interval = nether.v.abm_tree_interval,
	chance = nether.v.abm_tree_chance,
	action = function(pos)
		if minetest.get_node({x=pos.x, y=pos.y+2, z=pos.z}).name == "air"
		and minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "air" then
			local udata = minetest.registered_nodes[
				minetest.get_node{x=pos.x, y=pos.y-1, z=pos.z}.name]
			if udata
			and udata.groups
			and udata.groups.nether_dirt then
				nether.grow_tree(pos)
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"nether:netherrack_soil"},
	neighbors = {"air"},
	interval = 20,
	chance = 20,
	action = function(pos, node)
		local par2 = node.param2
		if par2 == 0 then
			return
		end
		pos.y = pos.y+1
		--mushrooms grow at dark places
		if (minetest.get_node_light(pos) or 16) > 7 then
			return
		end
		if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos, {name="riesenpilz:nether_shroom"})
			pos.y = pos.y-1
			minetest.set_node(pos,
				{name="nether:netherrack_soil", param2=par2-1})
		end
	end
})

local function grass_allowed(pos)
	local nd = minetest.get_node(pos).name
	if nd == "air" then
		return true
	end
	if nd == "ignore" then
		return 0
	end
	local data = minetest.registered_nodes[nd]
	if not data then
		-- unknown node
		return false
	end
	local drawtype = data.drawtype
	if drawtype
	and drawtype ~= "normal"
	and drawtype ~= "liquid"
	and drawtype ~= "flowingliquid" then
		return true
	end
	local light = data.light_source
	if light
	and light > 0 then
		return true
	end
	return false
end

minetest.register_abm({
	nodenames = {"nether:dirt"},
	interval = 20,
	chance = 9,
	action = function(pos)
		local allowed = grass_allowed({x=pos.x, y=pos.y+1, z=pos.z})
		if allowed == 0 then
			return
		end
		if allowed then
			minetest.set_node(pos, {name="nether:dirt_top"})
		end
	end
})

minetest.register_abm({
	nodenames = {"nether:dirt_top"},
	interval = 30,
	chance = 9,
	action = function(pos)
		local allowed = grass_allowed({x=pos.x, y=pos.y+1, z=pos.z})
		if allowed == 0 then
			return
		end
		if not allowed then
			minetest.set_node(pos, {name="nether:dirt"})
		end
	end
})


minetest.register_privilege("nether",
	"Allows sending players to nether and extracting them")

dofile(path.."/crafting.lua")
dofile(path.."/portal.lua")
dofile(path.."/guide.lua")


local time = (minetest.get_us_time() - load_time_start) / 1000000
local msg = ("[nether] loaded after ca. %g seconds."):format(time)
if time > 0.01 then
	print(msg)
else
	minetest.log("info", msg)
end
