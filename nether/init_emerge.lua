
-- This is run in mapgen env (see register_mapgen_script)

nether = {}
nether.env_type = "ssm_mapgen"

nether.path = minetest.get_modpath("nether")
local path = nether.path

dofile(path .. "/common.lua")
dofile(path .. "/grow_structures.lua")

dofile(path .. "/mapgen.lua")
