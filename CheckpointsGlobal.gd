extends Node

# check points

# save a spawn position where character starts
var spawn_position = Vector2()

# track the current scene so we know if a new scene was started
var current_scene = "none"

# track all items and enemies ...
var scene_objects = {}

# spawn position changed by check points
func update_spawn_position(position):
	spawn_position = position
