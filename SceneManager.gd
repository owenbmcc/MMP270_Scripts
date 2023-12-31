extends Node
"""
added in each scene to connect events to ui and game logic
logic for things like player deaths etc.
"""

# get reference to player to set position
@export var player : Node2D
@export var metrics_ui : Control

# references to scene path to change scene
@export_file var game_over_scene
@export_file var win_game_scene

# references to node, to load in scene
# add in UI canvas layer
@export var game_over_ui : Control
@export var win_game_ui : Control

func _ready():
	# hide uis if they exist
	if game_over_ui:
		game_over_ui.visible = false
	if win_game_ui:
		win_game_ui.visible = false

func _on_player_hit():
	lose_life()
	var is_alive = calc_lives()
	if not is_alive:
		_on_player_died()
	metrics_ui.update()
	
func _on_player_fall():
	lose_life()
	var is_alive = calc_lives()

	if is_alive:
		get_tree().reload_current_scene()
	else:
		_on_player_died()
	
func lose_life():
	if Global.props["life"] > 0:
		Global.props["life"] = Global.props["life"] - 1

func calc_lives():
	return Global.props["life"] > 0

func _on_player_died():
	player.die()
	Global.restart()
	ItemsGlobal.restart()
	CheckpointsGlobal.restart()
	
	# change to game over scene
	get_tree().change_scene_to_file(game_over_scene)
	
	# or load ui in scene
	# if game_over_ui:
		# game_over_ui.visible = true

# some items just count up, others have specific conditions
func _on_item_collected(item_type):
	if item_type == "life":
		if Global.props["life"] < Global.player_lives_max:
			Global.props["life"] = Global.props["life"] + 1
	else:
		if not Global.props.has(item_type):
			Global.props[item_type] = 0
		Global.props[item_type] = Global.props[item_type] + 1
	metrics_ui.update()

func _on_NPC_update_metrics():
	metrics_ui.update()

func _on_win_game():
	# change scenes:
	# get_tree().change_scene_to_file(win_game_scene)
	
	# or load ui in scene
	if win_game_ui:
		win_game_ui.visible = true
