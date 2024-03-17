
local path = nether.path
local in_mapgen_env = nether.env_type == "ssm_mapgen"

-- vars
local v = nether.v
local nether_middle = v.nether_middle
local f_bottom_scale = v.f_bottom_scale
local f_h_min = v.f_h_min
local f_h_max = v.f_h_max
local tree_rarity = v.tree_rarity
local glowflower_rarity = v.glowflower_rarity
local grass_rarity = v.grass_rarity
local mushroom_rarity = v.mushroom_rarity
local nether_start = v.nether_start
local NETHER_HEIGHT = v.NETHER_HEIGHT
local NETHER_RANDOM = v.NETHER_RANDOM
local GLOWSTONE_FREQ_ROOF = v.GLOWSTONE_FREQ_ROOF
local LAVA_FREQ = v.LAVA_FREQ
local nether_structure_freq = v.nether_structure_freq
local NETHER_SHROOM_FREQ = v.NETHER_SHROOM_FREQ
local NETHER_BOTTOM = v.NETHER_BOTTOM
local nether_buildings = v.nether_buildings

local nether_weird_noise = dofile(path .. "/weird_mapgen_noise.lua")

-- Weierstrass function stuff from https://github.com/slemonide/gen
local get_ws_list
do
	local SIZE = 1000
	local ssize = math.ceil(math.abs(SIZE))
	local function do_ws_func(depth, a, x)
		local n = math.pi * x / (16 * SIZE)
		local y = 0
		for k=1,depth do
			y = y + math.sin(k^a * n) / k^a
		end
		return SIZE * y / math.pi
	end

	local chunksize = minetest.settings:get"chunksize" or 5
	local ws_lists = {}
	get_ws_list = function(a,x)
			ws_lists[a] = ws_lists[a] or {}
			local v = ws_lists[a][x]
			if v then
					return v
			end
			v = {}
			for x=x,x + (chunksize*16 - 1) do
			local y = do_ws_func(ssize, a, x)
					v[x] = y
			end
			ws_lists[a][x] = v
			return v
	end
end

local function dif(z1, z2)
	return math.abs(z1-z2)
end

local function pymg(x1, x2, z1, z2)
	return math.max(dif(x1, x2), dif(z1, z2))
end

-- Generated variables
--~ local NETHER_ROOF_ABS = (nether_middle - NETHER_RANDOM)
local f_yscale_top = (f_h_max-f_h_min)/2
local f_yscale_bottom = f_yscale_top/2
--HADES_THRONE_STARTPOS_ABS = {x=HADES_THRONE_STARTPOS.x, y=(NETHER_BOTTOM +
--HADES_THRONE_STARTPOS.y), z=HADES_THRONE_STARTPOS.z}
--LAVA_Y = (NETHER_BOTTOM + LAVA_HEIGHT)
--HADES_THRONE_ABS = {}
--HADES_THRONE_ENDPOS_ABS = {}
--HADES_THRONE_GENERATED = minetest.get_worldpath() .. "/netherhadesthrone.txt"
--NETHER_SPAWNPOS_ABS = {x=NETHER_SPAWNPOS.x, y=(NETHER_BOTTOM +
--NETHER_SPAWNPOS.y), z=NETHER_SPAWNPOS.z}
--[[for i,v in ipairs(HADES_THRONE) do
	v.pos.x = v.pos.x + HADES_THRONE_STARTPOS_ABS.x
	v.pos.y = v.pos.y + HADES_THRONE_STARTPOS_ABS.y
	v.pos.z = v.pos.z + HADES_THRONE_STARTPOS_ABS.z
	HADES_THRONE_ABS[i] = v
end
local htx = 0
local hty = 0
local htz = 0
for i,v in ipairs(HADES_THRONE_ABS) do
	if v.pos.x > htx then
		htx = v.pos.x
	end
	if v.pos.y > hty then
		hty = v.pos.y
	end
	if v.pos.z > htz then
		htz = v.pos.z
	end
end
HADES_THRONE_ENDPOS_ABS = {x=htx, y=hty, z=htz}]]

local c, nether_tree_nodes, contents_defined
local function define_contents()
	if not contents_defined then
		c, nether_tree_nodes = nether.query_contents()
		contents_defined = true
	end
end

local pr

local function return_nether_ore(id, glowstone)
	if glowstone
	and pr:next(0,GLOWSTONE_FREQ_ROOF) == 1 then
		return c.glowstone
	end
	if id == c.coal then
		return c.netherrack_tiled
	end
	if id == c.gravel then
		return c.netherrack_black
	end
	if id == c.diamond then
		return c.netherrack_blue
	end
	if id == c.mese then
		return c.white
	end
	return c.netherrack
end

local f_perlins = {}

-- abs(v) < 1-(persistance^octaves))/(1-persistance) = amp
--local perlin1 = minetest.get_perlin(13,3, 0.5, 50) --Get map specific perlin
--	local perlin2 = minetest.get_perlin(133,3, 0.5, 10)
--	local perlin3 = minetest.get_perlin(112,3, 0.5, 5)
local tmp = f_yscale_top*4
local tmp2 = tmp/f_bottom_scale
local perlins = {
	{ -- amp 1.75
		seed = 13,
		octaves = 3,
		persist = 0.5,
		spread = {x=50, y=50, z=50},
		scale = 1,
		offset = 0,
	},
	{-- amp 1.75
		seed = 133,
		octaves = 3,
		persist = 0.5,
		spread = {x=10, y=10, z=10},
		scale = 1,
		offset = 0,
	},
	{-- amp 1.75
		seed = 112,
		octaves = 3,
		persist = 0.5,
		spread = {x=5, y=5, z=5},
		scale = 1,
		offset = 0,
	},
	--[[forest_bottom = {
		seed = 11,
		octaves = 3,
		persist = 0.8,
		spread = {x=tmp2, y=tmp2, z=tmp2},
		scale = 1,
		offset = 0,
	},]]
	forest_top = {-- amp 2.44
		seed = 21,
		octaves = 3,
		persist = 0.8,
		spread = {x=tmp, y=tmp, z=tmp},
		scale = 1,
		offset = 0,
	},
}

-- buffers, see https://forum.minetest.net/viewtopic.php?f=18&t=16043
local pelin_maps
local pmap1 = {}
local pmap2 = {}
local pmap3 = {}
local pmap_f_top = {}
local data = {}

local structures_enabled = true
local vine_maxlength = math.floor(NETHER_HEIGHT/4+0.5)
-- Create the Nether
local function on_generated(minp, maxp, seed)
	--avoid big map generation
	if not (maxp.y >= NETHER_BOTTOM-100 and minp.y <= nether_start) then
		return
	end

	local t1 = minetest.get_us_time()
	nether:inform("generates at: x=["..minp.x.."; "..maxp.x.."]; y=[" ..
		minp.y.."; "..maxp.y.."]; z=["..minp.z.."; "..maxp.z.."]", 2)

	define_contents()

	local buildings = 0
	if maxp.y <= NETHER_BOTTOM then
		buildings = 1
	elseif minp.y <= nether_buildings then
		buildings = 2
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	vm:get_data(data)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	pr = PseudoRandom(seed+33)
	local tab,num = {},1
	local trees,num_trees = {},1

	--local perlin1 = minetest.get_perlin(13,3, 0.5, 50)
	--local perlin2 = minetest.get_perlin(133,3, 0.5, 10)
	--local perlin3 = minetest.get_perlin(112,3, 0.5, 5)

	local side_length = maxp.x - minp.x + 1
	local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}

	if not pelin_maps then
		pelin_maps = {
			a = minetest.get_perlin_map(perlins[1], map_lengths_xyz),
			b = minetest.get_perlin_map(perlins[2], map_lengths_xyz),
			c = minetest.get_perlin_map(perlins[3], map_lengths_xyz),
			forest_top = minetest.get_perlin_map(perlins.forest_top,
				map_lengths_xyz),
		}
	end
	pelin_maps.a:get_2d_map_flat({x=minp.x, y=minp.z}, pmap1)
	pelin_maps.b:get_2d_map_flat({x=minp.x, y=minp.z}, pmap2)
	pelin_maps.c:get_2d_map_flat({x=minp.x, y=minp.z}, pmap3)

	local forest_possible = maxp.y > f_h_min and minp.y < f_h_max

	--local pmap_f_bottom = minetest.get_perlin_map(perlins.forest_bottom,
	-- map_lengths_xyz):get_2d_map_flat({x=minp.x, y=minp.z})
	local perlin_f_bottom, strassx, strassz
	if forest_possible then
		perlin_f_bottom = minetest.get_perlin(11, 3, 0.8, tmp2)
		pelin_maps.forest_top:get_2d_map_flat({x=minp.x, y=minp.z}, pmap_f_top)
		strassx = get_ws_list(2, minp.x)
		strassz = get_ws_list(2, minp.z)
	end

	local num2, tab2
	if buildings >= 1 then
		num2 = 1
		tab2 = nether_weird_noise({x=minp.x, y=nether_buildings-79, z=minp.z},
			pymg, 200, 8, 10, side_length-1)
	end

	local count = 0
	for z=minp.z, maxp.z do
		for x=minp.x, maxp.x do

			count = count+1

			local test = pmap1[count]+1
			local test2 = pmap2[count]
			local test3 = math.abs(pmap3[count])

			local t = math.floor(test*3+0.5)

			local h
			if test2 < 0 then
				h = math.floor(test2*3+0.5)-1
			else
				h = 3+t+pr:next(0,NETHER_RANDOM)
			end

			local generate_vine = false
			if test3 >= 0.72+pr:next(0,NETHER_RANDOM)/10
			and pr:next(0,NETHER_RANDOM) == 1 then
				generate_vine = true
			end

			local bottom = NETHER_BOTTOM+h
			local top = nether_middle-pr:next(0,NETHER_RANDOM)+t

			local py_h = 0
			local difn, noisp, py_h_g
			if buildings >= 1 then
				py_h = tab2[num2].y
				num2 = num2+1

				difn = nether_buildings-py_h
				if difn == 5 then
					noisp = 1
				elseif difn < 5 then
					noisp = 2
				end
				py_h_g = nether_buildings-7
			end

			local vi = area:index(x, minp.y, z)
			if buildings == 1
			and noisp then
				if noisp == 1 then
					for _ = 1,side_length do
						data[vi] = c.netherrack_brick
						vi = vi + area.ystride
					end
				else
					for _ = 1,side_length do
						data[vi] = c.lava
						vi = vi + area.ystride
					end
				end
			else

				local r_structure = pr:next(1,nether_structure_freq)
				local r_shroom = pr:next(1,NETHER_SHROOM_FREQ)
				local r_glowstone = pr:next(0,GLOWSTONE_FREQ_ROOF)
				local r_vine_length = pr:next(1,vine_maxlength)

				local f_bottom, f_top, is_forest, f_h_dirt
				if forest_possible then
					local p = {x=math.floor(x/f_bottom_scale),
						z=math.floor(z/f_bottom_scale)}
					local pstr = p.x.." "..p.z
					if not f_perlins[pstr] then
						f_perlins[pstr] = math.floor(f_h_min + (math.abs(
							perlin_f_bottom:get_2d{x=p.x, y=p.z} + 1))
							* f_yscale_bottom + 0.5)
					end
					local top_noise = pmap_f_top[count]+1
					if top_noise < 0 then
						top_noise = -top_noise/10
						--nether:inform("ERROR: (perlin noise) "..
						-- pmap_f_top[count].." is not inside [-1; 1]", 1)
					end
					f_top = math.floor(f_h_max - top_noise*f_yscale_top + 0.5)
					f_bottom = f_perlins[pstr]+pr:next(0,f_bottom_scale-1)
					is_forest = f_bottom < f_top
					f_h_dirt = f_bottom-pr:next(0,1)
				end

				for y=minp.y, maxp.y do
					local d_p_addp = data[vi]
					--if py_h >= maxp.y-4 then
					if y <= py_h
					and noisp then
						if noisp == 1 then
							data[vi] = c.netherrack_brick
						elseif noisp == 2 then
							if y == py_h then
								data[vi] = c.netherrack_brick
							elseif y == py_h_g
							and pr:next(1,3) <= 2 then
								data[vi] = c.netherrack
							elseif y <= py_h_g then
								data[vi] = c.lava
							else
								data[vi] = c.air
							end
						end
					elseif d_p_addp ~= c.air then

						if is_forest
						and y == f_bottom then
							data[vi] = c.nether_dirt_top
						elseif is_forest
						and y < f_bottom
						and y >= f_h_dirt then
							data[vi] = c.nether_dirt
						elseif is_forest
						and y == f_h_dirt-1 then
							data[vi] = c.nether_dirt_bottom
						elseif is_forest
						and y == f_h_dirt+1 then
							if pr:next(1,tree_rarity) == 1 then
								trees[num_trees] = {x=x, y=y, z=z}
								num_trees = num_trees+1
							elseif pr:next(1,mushroom_rarity) == 1 then
								data[vi] = c.nether_shroom
							elseif pr:next(1,glowflower_rarity) == 1 then
								data[vi] = c.glowflower
							elseif pr:next(1,grass_rarity) == 1 then
								data[vi] = c.nether_grass[pr:next(1,3)]
							else
								data[vi] = c.air
							end
						elseif is_forest
						and y > f_bottom
						and y < f_top then
							if not nether_tree_nodes[d_p_addp] then
								data[vi] = c.air
							end
						elseif is_forest
						and y == f_top then
							local sel = math.floor(strassx[x]+strassz[z]+0.5)%10
							if sel <= 5 then
								data[vi] = return_nether_ore(d_p_addp, true)
							elseif sel == 6 then
								data[vi] = c.netherrack_black
							elseif sel == 7 then
								data[vi] = c.glowstone
							else
								data[vi] = c.air
							end

						elseif y <= NETHER_BOTTOM then
							if y <= bottom then
								data[vi] = return_nether_ore(d_p_addp, true)
							else
								data[vi] = c.lava
							end
						elseif r_structure == 1
						and y == bottom then
							tab[num] = {x=x, y=y-1, z=z}
							num = num+1
						elseif y <= bottom then
							if pr:next(1,LAVA_FREQ) == 1 then
								data[vi] = c.lava
							else
								data[vi] = return_nether_ore(d_p_addp, false)
							end
						elseif r_shroom == 1
						and r_structure ~= 1
						and y == bottom+1 then
							data[vi] = c.nether_shroom
						elseif (y == top and r_glowstone == 1) then
							data[vi] = c.glowstone
						elseif y >= top then
							data[vi] = return_nether_ore(d_p_addp, true)
						elseif y <= top-1
						and generate_vine
						and y >= top-r_vine_length then
							data[vi] = c.nether_vine
						else
							data[vi] = c.air
						end
					end
					vi = vi + area.ystride
				end
			end
		end
	end

	nether:inform("most stuff set", 2, t1)

	local t2 = minetest.get_us_time()
	local bl_cnt = 0
	local tr_cnt = 0
	local tr_snd_cnt = 0

	if structures_enabled then -- Blood netherstructures
		bl_cnt = #tab
		for i = 1, #tab do
			nether.grow_netherstructure_into(area, data, tab[i], true)
		end
	end

	if bl_cnt > 0 then
		nether:inform(bl_cnt .. " blood structures set", 2, t2)
	end

	t2 = minetest.get_us_time()
	vm:set_data(data)
--	vm:set_lighting(12)
--	vm:calc_lighting()
--	vm:update_liquids()
	if not in_mapgen_env then
		vm:write_to_map(false)
	end
	nether:inform("data written", 2, t2)

	t2 = minetest.get_us_time()
	if forest_possible then -- Forest trees
		if in_mapgen_env then
			-- Trees can get too big (>16 nodes in one direction) for usual
			-- overgeneration onion layer. nether.grow_tree will make new vmanips
			-- to emerge blank (= ignore-filled) blocks to overcome this. But the
			-- main server thread needs to do this.
			tr_snd_cnt = #trees
			local trees_hashed = {}
			for i = 1, #trees do
				trees_hashed[i] = minetest.hash_node_position(trees[i])
			end
			assert(minetest.save_gen_notify("nether:please_grow_trees", trees_hashed))
		else
			tr_cnt = #trees
			for i = 1, #trees do
				nether.grow_tree(trees[i], true)
			end
		end
	end

	if tr_cnt + tr_snd_cnt > 0 then
		nether:inform(string.format("%s trees set, %s trees sent",
				tr_cnt, tr_snd_cnt), 2, t2)
	end

	if in_mapgen_env then
		assert(minetest.save_gen_notify("nether:please_fix_light", {minp, maxp}))
	else
		t2 = minetest.get_us_time()
		minetest.fix_light(minp, maxp)

		nether:inform("light fixed", 2, t2)
	end

	nether:inform("done", 1, t1)
end

if in_mapgen_env then
	minetest.register_on_generated(function(_, minp, maxp, blockseed)
		return on_generated(minp, maxp, blockseed)
	end)
else
	minetest.register_on_generated(on_generated)
end
