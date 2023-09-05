extends Node2D

# get player node to set position
export (NodePath) var player_path
onready var player = get_node(player_path)

# get all of the removable objects in a the scene (enemies and items)
export (Array, NodePath) var scene_objects_paths
var scene_objects = {}

# get current scene name
export var scene_name = ""

func _ready():
	
	for path in scene_objects_paths:
		var object = get_node(path)
		scene_objects[object.name] = object
	
	# checkpoints -- get scene name from var or parent node name
	if not scene_name:
		scene_name = get_parent().name
		
	print(scene_name, CheckpointsGlobal.current_scene)
	
	# if this is the current scene check validity of objects
	if scene_name == CheckpointsGlobal.current_scene:
		for object_name in CheckpointsGlobal.scene_objects[scene_name]:
			if CheckpointsGlobal.scene_objects[scene_name][object_name] == 0:
				scene_objects[object_name].queue_free()
	
	# if this is a new scene, update the player position
	if scene_name != CheckpointsGlobal.current_scene:
		CheckpointsGlobal.current_scene = scene_name
		CheckpointsGlobal.update_spawn_position(player.position)
		
		# get a list of all objects, 1 is keep them, 0 is remove them
		CheckpointsGlobal.scene_objects[scene_name] = {}
		for object_name in scene_objects:
			# to start all this objects exist 
			CheckpointsGlobal.scene_objects[scene_name][object_name] = 1
		
	# set the player to the current spawn position to keep up with checkpoints
	player.position = CheckpointsGlobal.spawn_position

func _on_game_over():
	for object_name in scene_objects:
		if not is_instance_valid(scene_objects[object_name]):
			CheckpointsGlobal.scene_objects[scene_name][object_name] = 0
