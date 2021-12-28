local default_settings = {
	trap_players = true,
	log_to_chat = false,
	log_level = 2,
	overworld_help = true,
}

nether.settings = {}

for name,dv in pairs(default_settings) do
	local setting
	local setting_name = "nether." .. name
	if type(dv) == "boolean" then
		setting = minetest.settings:get_bool(setting_name)
	elseif type(dv) == "number" then
		setting = tonumber(minetest.settings:get(setting_name))
	else
		error"[nether] Only boolean and number settings are available"
	end
	if setting == nil then
		setting = dv
	end
	nether[name] = setting
end
