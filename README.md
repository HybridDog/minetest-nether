For a description of this Minetest mod, please refer to the forum topic:
https://forum.minetest.net/viewtopic.php?f=9&t=10265


TODO:
* Mapgen: Find a way to get the perlin noise values inside [-1; 1] or use
  another noise.
  The problem is visible in the nether forest, where the mapgen code flattens
  the ceiling if it is very high.
* Mapgen: Generate more detail inside the simple pyramid-like "buildings",
  e.g. add a small treasure chest node which contains items
