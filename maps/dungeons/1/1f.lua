-- Lua script of map dungeons/3/1f.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local audio_manager = require("scripts/audio_manager")
local door_manager = require("scripts/maps/door_manager")
local enemy_manager = require("scripts/maps/enemy_manager")
local separator_manager = require("scripts/maps/separator_manager")
local switch_manager = require("scripts/maps/switch_manager")
local treasure_manager = require("scripts/maps/treasure_manager")

-- Event called at initialization time, as soon as this map is loaded.
map:register_event("on_started", function()
	separator_manager:manage_map(map)

-- Treasures
	treasure_manager:disappear_pickable(map, "pickable_32_small_key")
	treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_1_", "pickable_32_small_key")

-- Doors


  -- You can initialize the movement and sprites of various
  -- map entities here.
end)
