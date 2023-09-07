extends Node

# spawns player at saved checkpoints
# add Node2D to scene using checkpoints

# get current scene name, needed to track items, checkpoints
@export var scene_name : String

# get reference to player to set position
@export var player : Node2D

func _ready():
	
	# checkpoints -- get scene name from var or parent node name
	if scene_name.length() == 0:
		scene_name = get_parent().name
	
	# if this is a new scene, update the player position
	if scene_name != CheckpointsGlobal.current_scene:
		CheckpointsGlobal.current_scene = scene_name
		CheckpointsGlobal.update_spawn_position(player.position)
		
	# set the player to the current spawn position to keep up with checkpoints
	player.position = CheckpointsGlobal.spawn_position


func _on_checkpoint_activated(checkpoint_position):
	CheckpointsGlobal.update_spawn_position(checkpoint_position)
