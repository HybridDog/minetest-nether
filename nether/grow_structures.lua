
local netherstructure_height = 6

local function vmanip_with_r_area(width, height, pos)
	local manip = minetest.get_voxel_manip()
	local emerged_pos1, emerged_pos2 = manip:read_from_map(
		{x=pos.x-width, y=pos.y, z=pos.z-width},
		{x=pos.x+width, y=pos.y+height, z=pos.z+width}
	)
	return manip, VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
end

local function inform_grow(pos, t1, name, generated)
	nether:inform(name.." grew at " .. minetest.pos_to_string(pos),
		generated and 3 or 2, t1)
end

local function set_vm_data(manip, nodes, pos, t1, name, generated)
	manip:set_data(nodes)
	manip:write_to_map(not generated)
	inform_grow(pos, t1, name, generated)
end

local c, contents_defined
local function define_contents()
	if not contents_defined then
		c = nether.query_contents()
		contents_defined = true
	end
end

local function grow_netherstructure_into_raw(area, nodes, pos, generated)
	define_contents()

	local height = netherstructure_height

	local vi = area:indexp(pos)
	for _ = 0, height-1 do
		nodes[vi] = c.blood_stem
		vi = vi + area.ystride
	end

	for i = -1,1 do
		for j = -1,1 do
			nodes[area:index(pos.x+i, pos.y+height, pos.z+j)] = c.blood_top
		end
	end

	for k = -1, 1, 2 do
		for l = -2+1, 2 do
			local p1 = {pos.x+2*k, pos.y+height, pos.z-l*k}
			local p2 = {pos.x+l*k, pos.y+height, pos.z+2*k}
			local udat = c.blood_top
			if math.random(2) == 1 then
				nodes[area:index(p1[1], p1[2], p1[3])] = c.blood_top
				nodes[area:index(p2[1], p2[2], p2[3])] = c.blood_top
				udat = c.blood
			end
			nodes[area:index(p1[1], p1[2]-1, p1[3])] = udat
			nodes[area:index(p2[1], p2[2]-1, p2[3])] = udat
		end
		for l = 0, 1 do
			for _,p in ipairs({
				{pos.x+k, pos.y+height-1, pos.z-l*k},
				{pos.x+l*k, pos.y+height-1, pos.z+k},
			}) do
				if math.random(2) == 1 then
					nodes[area:index(p[1], p[2], p[3])] = c.nether_apple
				--elseif math.random(10) == 1 then
				--	nodes[area:index(p[1], p[2], p[3])] = c.apple
				end
			end
		end
	end
end

function nether.grow_netherstructure_into(area, nodes, pos, generated)
	local t1 = minetest.get_us_time()

	if not pos.x then print(dump(pos))
		nether:inform("Error: "..dump(pos), 1)
		return
	end

	grow_netherstructure_into_raw(area, nodes, pos, generated)

	inform_grow(pos, t1, "blood", generated)
end

function nether.grow_netherstructure(pos, generated)
	local t1 = minetest.get_us_time()

	if not pos.x then print(dump(pos))
		nether:inform("Error: "..dump(pos), 1)
		return
	end

	local height = netherstructure_height
	local manip, area = vmanip_with_r_area(2, height, pos)
	local nodes = manip:get_data()

	grow_netherstructure_into_raw(area, nodes, pos, generated)

	set_vm_data(manip, nodes, pos, t1, "blood", generated)
end

local poshash = minetest.hash_node_position
local pos_from_hash = minetest.get_position_from_hash

local function soft_node(id)
	return id == c.air or id == c.ignore
end

local function update_minmax(min, max, p)
	min.x = math.min(min.x, p.x)
	max.x = math.max(max.x, p.x)
	min.z = math.min(min.z, p.z)
	max.z = math.max(max.z, p.z)
end

local fruit_chances = {}
for y = -2,1 do --like a hyperbola
	fruit_chances[y] = math.floor(-4/(y-2)+0.5)
end

local dirs = {
	{-1, 0, 12, 19},
	{1, 0, 12, 13},
	{0, 1, 4},
	{0, -1, 4, 10},
}

local h_max = 26
local h_stem_min = 3
local h_stem_max = 7
local h_arm_min = 2
local h_arm_max = 6
local r_arm_min = 1
local r_arm_max = 5
local fruit_rarity = 25 --a bigger number results in less fruits
local leaf_thickness = 3 --a bigger number results in more blank trees

local h_trunk_max = h_max-h_arm_max

function nether.grow_tree(pos, generated)
	local t1 = minetest.get_us_time()

	define_contents()

	local min = vector.new(pos)
	local max = vector.new(pos)
	min.y = min.y-1
	max.y = max.y+h_max

	local trunks = {}
	local trunk_corners = {}
	local h_stem = math.random(h_stem_min, h_stem_max)
	local todo,n = {{x=pos.x, y=pos.y+h_stem, z=pos.z}},1
	while n do
		local p = todo[n]
		todo[n] = nil
		n = next(todo)

		local used_dirs,u = {},1
		for _,dir in pairs(dirs) do
			if math.random(1,2) == 1 then
				used_dirs[u] = dir
				u = u+1
			end
		end
		if not used_dirs[1] then
			local dir1 = math.random(4)
			local dir2 = math.random(3)
			if dir1 <= dir2 then
				dir2 = dir2+1
			end
			used_dirs[1] = dirs[dir1]
			used_dirs[2] = dirs[dir2]
		end
		for _,dir in pairs(used_dirs) do
			local p = vector.new(p)
			local r = math.random(r_arm_min, r_arm_max)
			for j = 1,r do
				local x = p.x+j*dir[1]
				local z = p.z+j*dir[2]
				trunks[poshash{x=x, y=p.y, z=z}] = dir[3]
			end
			r = r+1
			p.x = p.x+r*dir[1]
			p.z = p.z+r*dir[2]
			trunk_corners[poshash(p)] = dir[4] or dir[3]
			local h = math.random(h_arm_min, h_arm_max)
			for i = 1,h do
				p.y = p.y + i
				trunks[poshash(p)] = true
				p.y = p.y - i
			end
			p.y = p.y+h
			--n = #todo+1 -- caused small trees
			todo[#todo+1] = p
		end
		if p.y > pos.y+h_trunk_max then
			break
		end

		n = n or next(todo)
	end
	local leaves = {}
	local fruits = {}
	local trunk_ps = {}
	local count = 0

	local ps = {}
	local trunk_count = 0
	for i,par2 in pairs(trunks) do
		local pos = pos_from_hash(i)
		update_minmax(min, max, pos)
		local z,y,x = pos.z, pos.y, pos.x
		trunk_count = trunk_count+1
		ps[trunk_count] = {z,y,x, par2}
	end

	for _,d in pairs(ps) do
		if d[4] == true then
			d[4] = nil
		end
		trunk_ps[#trunk_ps+1] = d
		local pz, py, px = unpack(d)
		count = count+1
		if count > leaf_thickness then
			count = 0
			for y = -2,2 do
				local fruit_chance = fruit_chances[y]
				for z = -2,2 do
					for x = -2,2 do
						local distq = x*x+y*y+z*z
						if distq ~= 0
						and math.random(1, math.sqrt(distq)) == 1 then
							local x = x+px
							local y = y+py
							local z = z+pz
							local vi = poshash{x=x, y=y, z=z}
							if not trunks[vi] then
								if fruit_chance
								and math.random(1, fruit_rarity) == 1
								and math.random(1, fruit_chance) == 1 then
									fruits[vi] = true
								else
									leaves[vi] = true
								end
								update_minmax(min, max, {x=x, z=z})
							end
						end
					end
				end
			end
		end
	end

	--ps = nil
	--collectgarbage()

	for i = -1,h_stem+1 do
		-- param2 explicitly set 0 due to possibly previous leaves node
		trunk_ps[#trunk_ps+1] = {pos.z, pos.y+i, pos.x, 0}
	end

	local manip = minetest.get_voxel_manip()
	local emerged_pos1, emerged_pos2 = manip:read_from_map(min, max)
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
	local nodes = manip:get_data()
	local param2s = manip:get_param2_data()

	for i in pairs(leaves) do
		local p = area:indexp(pos_from_hash(i))
		if soft_node(nodes[p]) then
			nodes[p] = c.nether_leaves
			param2s[p] = math.random(0,179)
			--param2s[p] = math.random(0,44)
		end
	end

	for i in pairs(fruits) do
		local p = area:indexp(pos_from_hash(i))
		if soft_node(nodes[p]) then
			nodes[p] = c.nether_apple
		end
	end

	for i = 1,#trunk_ps do
		local p = trunk_ps[i]
		local par = p[4]
		p = area:index(p[3], p[2], p[1])
		if par then
			param2s[p] = par
		end
		nodes[p] = c.nether_tree
	end

	for i,par2 in pairs(trunk_corners) do
		local vi = area:indexp(pos_from_hash(i))
		nodes[vi] = c.nether_tree_corner
		param2s[vi] = par2
	end

	manip:set_data(nodes)
	manip:set_param2_data(param2s)
	manip:write_to_map(not generated)
	nether:inform("a nether tree with " .. trunk_count ..
		" branch trunk nodes grew at " .. minetest.pos_to_string(pos),
		generated and 3 or 2, t1)
end
