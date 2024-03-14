
dofile(nether.path .. "/settings.lua")

-- vars
nether.v = {}
local v = nether.v

--== EDITABLE OPTIONS ==--

-- Depth of the nether
v.nether_middle = -20000

-- forest bottom perlin multiplication
v.f_bottom_scale = 4

-- forest bottom height
v.f_h_min = v.nether_middle+10

-- forest top height
v.f_h_max = v.f_h_min+250

-- Frequency of trees in the nether forest (higher is less frequent)
v.tree_rarity = 200

-- Frequency of glowflowers in the nether forest (higher is less frequent)
v.glowflower_rarity = 120

-- Frequency of nether grass in the nether forest (higher is less frequent)
v.grass_rarity = 2

-- Frequency of nether mushrooms in the nether forest (higher is less frequent)
v.mushroom_rarity = 80

v.abm_tree_interval = 864
v.abm_tree_chance = 100

-- height of the nether generation's end
v.nether_start = v.f_h_max+100

-- Height of the nether (bottom of the nether is nether_middle - NETHER_HEIGHT)
v.NETHER_HEIGHT = 30

-- bottom height of the nether.
v.nether_bottom = v.nether_middle - v.NETHER_HEIGHT - 100

-- Maximum amount of randomness in the map generation
v.NETHER_RANDOM = 2

-- Frequency of Glowstone on the "roof" of the Nether (higher is less frequent)
v.GLOWSTONE_FREQ_ROOF = 500

-- Frequency of lava (higher is less frequent)
v.LAVA_FREQ = 100

v.nether_structure_freq = 350
v.NETHER_SHROOM_FREQ = 100

-- Maximum height of lava
--v.LAVA_HEIGHT = 2
-- Frequency of Glowstone on lava (higher is less frequent)
--v.GLOWSTONE_FREQ_LAVA = 2
-- Height of nether structures
--v.NETHER_TREESIZE = 2
-- Frequency of apples in a nether structure (higher is less frequent)
--v.NETHER_APPLE_FREQ = 5
-- Frequency of healing apples in a nether structure (higher is less frequent)
--v.NETHER_HEAL_APPLE_FREQ = 10
-- Start position for the Throne of Hades (y is relative to the bottom of the
-- nether)
--v.HADES_THRONE_STARTPOS = {x=0, y=1, z=0}
-- Spawn pos for when the nether hasn't been loaded yet (i.e. no portal in the
-- nether) (y is relative to the bottom of the nether)
--v.NETHER_SPAWNPOS = {x=0, y=5, z=0}
-- Structure of the nether portal (all is relative to the nether portal creator
-- block)

--== END OF EDITABLE OPTIONS ==--

-- Generated variables
v.NETHER_BOTTOM = (v.nether_middle - v.NETHER_HEIGHT)
v.nether_buildings = v.NETHER_BOTTOM+12

function nether.query_contents()
	local c = {
		ignore = minetest.get_content_id("ignore"),
		air = minetest.get_content_id("air"),
		lava = minetest.get_content_id("default:lava_source"),
		gravel = minetest.get_content_id("default:gravel"),
		coal = minetest.get_content_id("default:stone_with_coal"),
		diamond = minetest.get_content_id("default:stone_with_diamond"),
		mese = minetest.get_content_id("default:mese"),

		--https://github.com/Zeg9/minetest-glow
		glowstone = minetest.get_content_id("glow:stone"),

		nether_shroom = minetest.get_content_id("riesenpilz:nether_shroom"),

		netherrack = minetest.get_content_id("nether:netherrack"),
		netherrack_tiled = minetest.get_content_id("nether:netherrack_tiled"),
		netherrack_black = minetest.get_content_id("nether:netherrack_black"),
		netherrack_blue = minetest.get_content_id("nether:netherrack_blue"),
		netherrack_brick = minetest.get_content_id("nether:netherrack_brick"),
		white = minetest.get_content_id("nether:white"),

		nether_vine = minetest.get_content_id("nether:vine"),
		blood = minetest.get_content_id("nether:blood"),
		blood_top = minetest.get_content_id("nether:blood_top"),
		blood_stem = minetest.get_content_id("nether:blood_stem"),
		nether_apple = minetest.get_content_id("nether:apple"),

		nether_tree = minetest.get_content_id("nether:tree"),
		nether_tree_corner = minetest.get_content_id("nether:tree_corner"),
		nether_leaves = minetest.get_content_id("nether:leaves"),
		nether_grass = {
			minetest.get_content_id("nether:grass_small"),
			minetest.get_content_id("nether:grass_middle"),
			minetest.get_content_id("nether:grass_big")
		},
		glowflower = minetest.get_content_id("nether:glowflower"),
		nether_dirt = minetest.get_content_id("nether:dirt"),
		nether_dirt_top = minetest.get_content_id("nether:dirt_top"),
		nether_dirt_bottom = minetest.get_content_id("nether:dirt_bottom"),
	}
	local trn = {c.nether_tree, c.nether_tree_corner, c.nether_leaves,
		c.nether_fruit}
	local nether_tree_nodes = {}
	for i = 1,#trn do
		nether_tree_nodes[trn[i]] = true
	end

	return c, nether_tree_nodes
end

if nether.log_level >= 1 then
	function nether:inform(msg, spam, t)
		if spam <= self.log_level then
			local info
			if t then
				info = "[nether] " .. msg .. (" after ca. %.3g s"):format(
					(minetest.get_us_time() - t) / 1000000)
			else
				info = "[nether] " .. msg
			end
			print(info)
			if self.log_to_chat then
				minetest.chat_send_all(info)
			end
		end
	end
else
	function nether.inform()
	end
end
