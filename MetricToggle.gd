extends Node

# metric that is either on or off based on a value number, like number of lives
@export var metric_name : String = "item"

@export var display_sprites_paths : Array[NodePath]
var display_sprites = Array()

func _ready():
	for path in display_sprites_paths:
		display_sprites.append(get_node(path))

# update called by metrics manager
func update_display(value):
	for i in display_sprites.size():
		display_sprites[i].visible = ((i + 1) <= value)
