-- The content of the guide
local guide_infos = {
	{"Nether Mushroom",
[[Nether mushrooms can be found on the nether's ground and on Dirty Netherrack. They can be dug by hand.
<item name=riesenpilz:nether_shroom width=100>

<my_h2><b>Crafting Items</b></my_h2>
If we drop a Nether mushroom without holding the fast key, we can split it into its stem and head. We can use them to craft a Nether Mushroom Pickaxe, a Nether Blood Extractor, and an uncooked Nether Pearl.
<item name=nether:shroom_head width=100> <item name=nether:shroom_stem width=100>

<my_h2><b>Cultivating Mushrooms</b></my_h2>
We can get more mushrooms using Dirty Netherrack:
1. Search a dark place (light level <= 7) and, if necessary, place Netherrack with air above it
  <img name=nether_netherrack.png width=100>
2. Right click with Cooked Blood onto the Netherrack to turn it into Dirty Netherrack
  <item name=nether:hotbed width=100> <img name=nether_netherrack.png^nether_netherrack_soil.png width=100>
3. Right click onto the Dirty Netherrack with a Nether mushroom head to add some spores
  <item name=nether:shroom_head width=100> <img name=nether_netherrack.png^nether_netherrack_soil.png width=100>
4. Wait
5. Dig the Nether mushroom which grew after some time to make place for another one. After some time new spores need to be added (step 3).
  <img name=riesenpilz_nether_shroom_side.png width=100>
  <img name=nether_netherrack.png^nether_netherrack_soil.png width=100>
]]},

	{"Blood Structures",
[[We can find blood structures on the ground and dig their nodes with the bare hand. They contain four kinds of nodes: Nether Blood Stem, Nether Blood, Nether Blood Head, and Nether Fruit.
<item name=nether:blood_stem width=100> <item name=nether:blood width=100> <item name=nether:apple width=100>
We can craft four Nether Blood Wood nodes with the stem.
<item name=nether:wood width=100>
The four red blood nodes can be cooked in a furnace and, except Nether Blood Wood, their blood can be extracted with a Nether Blood Extractor.

<my_h2><b>Nether Fruit</b></my_h2>
<item name=nether:apple width=100>
Eating a Nether Fruit decreases life but it might work against hunger and give us blood:
<item name=nether:blood_extracted width=100>
If we eat it at the right place inside a portal, we will teleport instead of getting blood.
If we drop it without holding the fast key, we can split it into its fruit and leaf:
<item name=nether:fruit_leaf width=100> <item name=nether:fruit_no_leaf width=100>
We can craft a fruit leave block out of 9 fruit leaves
The fruit can be used to craft a nether pearl.
<item name=nether:fruit_leaves width=100>
A fruit leaves block

<my_h2><b>Cultivating Blood Structures</b></my_h2>
If we dig a Nether vine we get a Nether Blood Child. If this sapling is put in a dark place (light level <= 3) on top of a Nether Blood Head node, it grows into a new blood structure after some time.
<img name=nether_sapling.png width=100>
<img name=nether_blood.png^nether_blood_side.png width=100>
]]},

	{"Tools",
[[We can craft five kinds of tools in the nether, which (except the Nether Mushroom Pickaxe) require sticks to be crafted. To obtain Nether Sticks we can use the Nether Blood Extractor.

<my_h2><b>Nether Mushroom Pickaxe</b></my_h2>
<item name=nether:pick_mushroom width=100>
Strength: 1
This pickaxe needs mushroom stems and heads to be crafted.

<my_h2><b>Nether Wood Pickaxe</b></my_h2>
<item name=nether:pick_wood width=100>
Strength: 2
This pickaxe can be crafted with Cooked Nether Blood Wood.

<my_h2><b>Netherrack Tools</b></my_h2>
<item name=nether:axe_netherrack width=100> <item name=nether:shovel_netherrack width=100> <item name=nether:sword_netherrack width=100> <item name=nether:pick_netherrack width=100>
Strength: 3
The red Netherrack tools can be crafted with usual Netherrack.

<my_h2><b>Faster Tools</b></my_h2>
<item name=nether:axe_netherrack_blue width=100> <item name=nether:shovel_netherrack_blue width=100> <item name=nether:sword_netherrack_blue width=100> <item name=nether:pick_netherrack_blue width=100>
Strength: 3
The blue Netherrack tools can be crafted with Blue Netherrack.

<item name=nether:axe_white width=100> <item name=nether:shovel_white width=100> <item name=nether:sword_white width=100> <item name=nether:pick_white width=100>
Strength: 3
The Siwtonic tools can be crafted with the Siwtonic block.
]]},

	{"Cooking",
[[To get a furnace we need to dig at least 8 Netherrack Bricks. They can be found at pyramid-like constructions and require at least a strength 1 nether pickaxe to be dug.
To begin cooking things, we can use a mushroom or fruit to power a furnace. After that it is recommended to use cooked blood nodes.

<my_h2><b>Craft Recipe</b></my_h2>
To craft the furnace, we can use the netherrack bricks like cobble:
<item name=nether:netherrack_brick width=100> <item name=nether:netherrack_brick width=100> <item name=nether:netherrack_brick width=100>
<item name=nether:netherrack_brick width=100> <img name=nether_transparent.png width=100> <item name=nether:netherrack_brick width=100>
<item name=nether:netherrack_brick width=100> <item name=nether:netherrack_brick width=100> <item name=nether:netherrack_brick width=100>

<my_h2><b>Cooking Outputs</b></my_h2>
Some nether items can be cooked, for example the Blood Structure's nodes.
<item name=nether:blood_stem_cooked width=100> <item name=nether:blood_cooked width=100> <item name=nether:blood_top_cooked width=100> <item name=nether:wood_cooked width=100>
Other cookable items are Blood and an item to get a Nether Pearl.
<item name=nether:hotbed width=100> <item name=nether:pearl width=100>
]]},

	{"Nether Blood Extractor",
[[With this extractor we can separate Blood from the Blood Structure's nodes. An alternative way to get Blood is to eat Nether Fruits. The Nether Blood Extractor enables us to obtain a Nether Blood Stem Extracted, which we can craft to (empty) Nether Wood and then to Nether Sticks.

<my_h2><b>Craft Recipe</b></my_h2>
We can craft the Nether Blood Extractor as follows:
<item name=nether:netherrack_brick width=100> <item name=nether:blood_top_cooked width=100> <item name=nether:netherrack_brick width=100>
<item name=nether:blood_cooked width=100> <item name=nether:shroom_stem width=100> <item name=nether:blood_cooked width=100> <img name=nether_transparent.png width=100> <item name=nether:extractor width=100>
<item name=nether:netherrack_brick width=100> <item name=nether:blood_stem_cooked width=100> <item name=nether:netherrack_brick width=100>

<my_h2><b>Usage</b></my_h2>
We can feed the extractor with Blood to make it separate Blood from neighbouring nodes:
1. Place the Nether Blood Extractor somewhere
2. Place four or fewer Blood Structure's nodes next to it. Example viewed from the top:
<img name=nether_transparent.png width=100> <img name=nether_blood_stem_top.png width=100> <img name=nether_transparent.png width=100>
<img name=nether_blood.png width=100> <img name=nether_blood_extractor.png width=100> <img name=nether_blood.png width=100>
<img name=nether_transparent.png width=100> <img name=nether_blood.png width=100> <img name=nether_transparent.png width=100>
3. Right click the extractor with Blood to power it
<img name=nether_transparent.png width=100> <img name=nether_blood_stem_top_empty.png width=100> <img name=nether_transparent.png width=100>
<img name=nether_blood_empty.png width=100> <img name=nether_blood_extractor.png width=100> <img name=nether_blood_empty.png width=100>
<img name=nether_transparent.png width=100> <img name=nether_blood_empty.png width=100> <img name=nether_transparent.png width=100>
4. Take the new extracted blood and dig the extracted nodes
]]},

	{"Ores and Bricks",
[[Digging ores requires a pickaxe from the nether of a sufficient strength. Pickaxes from the overworld do not work in general.

<my_h2><b>Strength 1</b></my_h2>
<item name=glow:stone width=100>
The Glowing stone can be dug with pickaxes from the overworld or a pickaxe from the nether with a strenght of least one. We can find it on the nether's and nether forest's ceiling and use it for lighting.

<my_h2><b>Strength 2</b></my_h2>
<item name=nether:netherrack width=100> <item name=nether:netherrack_tiled width=100> <item name=nether:netherrack_black width=100>
The (red) Netherrack is generated like stone, Tiled Netherrack is generated like coal ore and the Black Netherrack is generated like gravel.

<my_h2><b>Strength 3</b></my_h2>
<item name=nether:netherrack_blue width=100> <item name=nether:white width=100>
The Blue Netherrack is generated like diamond ore and the Siwtonic block is generated like mese blocks.

<my_h2><b>Bricks</b></my_h2>
There are three types of Bricks: red, Blue, and Black Netherrack Brick. We can craft them from the corresponding Netherrack nodes and additionally, the (red) Netherrack Brick is generated in pyramid-like structures in the nether. In comparison to the Netherrack nodes, all three Bricks can be dug with a pickaxe with strength 1.
<item name=nether:netherrack_brick width=100> <item name=nether:netherrack_brick_blue width=100> <item name=nether:netherrack_brick_black width=100>
]]},

	{"Nether Vines",
[[Nether vines are at the ceiling of the nether and can be dug by hand. They drop Nether Blood Child nodes, from which we can grow Blood Structures. By feeding Blood to a Nether vine with air beneath it, it grows one node.
<item name=nether:vine width=100>
]]},

	{"Portals",
[[This nether mod supports two types of portals: the well-known Minecraft-like one made of Obsidian, and a portal which is specific to this mod. The Obsidian portal allows us to reach the nether from the overworld, but it is one-way and kills us.

<my_h2><b>Build Instructions</b></my_h2>
A nether portal requires the following nodes:
<item name=nether:wood_empty width=100> <item name=nether:netherrack_black width=100> <item name=nether:netherrack_brick_blue width=100> <item name=nether:netherrack width=100>  <item name=nether:blood_cooked width=100> <item name=nether:apple width=100> <item name=nether:white width=100>
* 25 (empty) Nether Wood (height 5-6)
* 16 Black Netherrack (height 1)
* 12 Blue Netherrack Bricks (height 2-4)
* 8 (red) Netherrack (height 1)
* 8 Cooked Nether Blood (height 5)
* 4 Nether Fruits (height 4)
* 2 Siwtonic blocks (height 1 and 5)

The heights in parenthesis correspond to the relative vertical positions of the nodes. When built, the portal should look approximately like this one:
<img name=nether_teleporter.png width=600>

<my_h2><b>Usage</b></my_h2>
Before using the portal the first time, we may want to fill our inventory with enough items so that we can build a second portal on the overworld to get back.
We can activate the portal as follows:
1. Stand in the middle on the Siwtonic block
2. Eat a Nether Fruit. If the portal was built correctly, we can hear a special sound and are teleported to the overworld.

If two portals in the nether and overworld have the same X and Z coordinates, they teleport us to the centre, i.e. onto the Siwtonic block, of the opposite portal when eating a Nether Fruit.
]]},

	{"Pearls",
[[The nether pearl can be used to teleport by throwing it.

<my_h2><b>Craft Recipe</b></my_h2>
First, we need to craft two Nether Mushroom Heads and a Nether Fruit Without Leaf together as follows:
<item name=nether:shroom_head width=100>
<item name=nether:fruit_no_leaf width=100>
<item name=nether:shroom_head width=100>
This gives us the Nether Fruit in Mushroom (FIM), which we can cook in a furnace to obtain a Nether Pearl.
<item name=nether:fim width=100> <item name=nether:pearl width=100>
]]},

	{"Nether Forest",
[[The nether forest is generated in caves above the nether and contains decorative plants.

<my_h2><b>Grass and Flower</b></my_h2>
<item name=nether:grass_big width=100> <item name=nether:grass_middle width=100> <item name=nether:grass_small width=100>
We can craft the Nether Grass item to another grass item, which can be cooked to get Dried Nether Grass. We can then craft this dried grass to paper.

<item name=nether:glowflower width=100>
The Glowing Flower can be used for lighting and decoration.

<my_h2><b>Nether Tree</b></my_h2>
<item name=nether:tree width=100>
Nether trunks can be found at Nether Trees and be crafted into Nether Wood Blocks via Nether Wood Planks. Furthermore, the Nether Tree Saplings grow even in the overworld if they have Nether Dirt beneath them.
]]}
}

-- The guide formspecs
local guide_forms = {}

-- Convert the guide content to formspecs
for n,data in ipairs(guide_infos) do
	local title, html_content = data[1], data[2]
	--~ local html_text = "<global background=#242424 size=24><tag name=my_h1 size=35>" ..
	local html_text = "<global size=24><tag name=my_h1 size=35>" ..
		"<tag name=my_h2 size=30>" ..
		"<my_h1><b><center>" .. title .. "</b></center></my_h1>\n" ..
		html_content
	local spec_width = 16
	local spec_height = 16
	local html_padding = 0.5
	local form = ("formspec_version[4]size[%g,%g;]" ..
			"hypertext[%g,%g;%g,%g;html;%s]button[%g,%g;2,0.8;quit;Back]"
		):format(
		spec_width, spec_height,
		html_padding, html_padding,
		spec_width - 2 * html_padding, spec_height - 1 - 2 * html_padding,
		minetest.formspec_escape(html_text),
		0.5 * spec_width - 1, spec_height - 1)

	guide_forms[n] = {title, form}
end

local title_to_index = {}
for n, i in ipairs(guide_forms) do
	title_to_index[i[1]] = n
end

-- Create the contents formspec
guide_forms.contents = "formspec_version[4]size[6," .. (#guide_infos) + 2 ..
	";]label[2,0.8;Contents:]"
for i, data in ipairs(guide_forms) do
	local desc = data[1]
	local y = i + 0.5 + 0.1
	guide_forms.contents = guide_forms.contents ..
		"button[0.5," .. y .. ";5,0.8;name;" .. desc .. "]"
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "nether_guide_contents" then
		local fname = fields.name
		local pname = player:get_player_name()
		if fname
		and pname then
			minetest.show_formspec(pname, "nether_guide",
				guide_forms[title_to_index[fname]][2])
		end
	elseif formname == "nether_guide" then
		local fname = fields.quit
		local pname = player:get_player_name()
		if fname
		and pname then
			minetest.show_formspec(pname, "nether_guide_contents",
				guide_forms["contents"])
		end
	end
end)

minetest.register_chatcommand("nether_help", {
	params = "",
	description = "Shows a nether guide",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Something went wrong."
		end
		if not nether.overworld_help and player:get_pos().y > nether.v.nether_start then
			return false, "Usually you don't neet this guide here. " ..
				"You can view it in the nether."
		end
		minetest.chat_send_player(name, "Showing guide...")
		-- Show the Contents (overview) page
		minetest.show_formspec(name, "nether_guide_contents",
			guide_forms["contents"])
		return true
	end
})
