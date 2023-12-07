extends Node
"""
track objects removed from scene
0 means they are removed, 1 still active
save_objects_states save the current items states, 
	connect to signal for player death
	or checkpoints etc

node setup
• Node2D (Level 1)
	• Node (ItemManager)
"""


# get current scene name, needed to track items, checkpoints
@export var scene_name : String

# get all of the removable objects in a the scene (enemies and items)
@export var track_nodes : Array[NodePath] # track specific nodes
@export var track_children : Array[NodePath] # track all children of a node
var scene_objects : Dictionary = {}

func _ready():
	
	for node_path in track_nodes:
		var node = get_node(node_path)
		scene_objects[node.name] = node
		
	for node_path in track_children:
		for node in get_node(node_path).get_children():
			scene_objects[node.name] = node
	
	# checkpoints -- get scene name from var or parent node name
	if scene_name.length() == 0:
		scene_name = get_parent().name
	
	# if this is the current scene check if objects should be removed
	# 0 means remove object (use enum?)
	if scene_name == ItemsGlobal.current_scene:
		for obj_name in ItemsGlobal.scene_objects[scene_name]:
			if ItemsGlobal.scene_objects[scene_name][obj_name] == 0:
				scene_objects[obj_name].queue_free()
	
	# if this is a new scene, update the player position
	if scene_name != ItemsGlobal.current_scene:
		ItemsGlobal.current_scene = scene_name
		# get a list of all objects, 1 is keep them, 0 is remove them
		ItemsGlobal.scene_objects[scene_name] = {}
		for obj_name in scene_objects:
			# to start all this objects exist 
			ItemsGlobal.scene_objects[scene_name][obj_name] = 1

# if player game overs check objects in scene
# conntect game over to scene manager
func _on_player_died():
	save_objects_states()
	
func save_objects_states():
	for obj_name in scene_objects:
		if not is_instance_valid(scene_objects[obj_name]):
			ItemsGlobal.scene_objects[scene_name][obj_name] = 0

# tracks number of collectibles
# specific logic goes in scene manager
func _on_collectible_collected(collectible_type):
	if not ItemsGlobal.collectibles[collectible_type]:
		ItemsGlobal.collectibles[collectible_type] = 0
	ItemsGlobal.collectibles[collectible_type] = ItemsGlobal.collectibles[collectible_type] + 1

# connect to checkpoints to save state of objects
func _on_checkpoint_activated(_checkpoint_position):
	save_objects_states()
