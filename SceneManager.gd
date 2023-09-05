extends Node2D

export (NodePath) var player_path
onready var player = get_node(player_path)

export (NodePath) var game_over_path
onready var game_over_ui = get_node(game_over_path)

export (NodePath) var metrics_path
onready var metrics = get_node(metrics_path)

func _ready():
	pass # game_over_ui.visible = false

func _on_player_hit(is_alive):
	# game_over_ui.visible = true
	
	if is_alive and Global.player_lives > 0:
		Global.player_lives = Global.player_lives - 1
		
	if not is_alive or Global.player_lives <= 0:
		player.dies()
	

func _on_item_collected(item_type):
	if item_type == "apple":
		Global.item_count = Global.item_count + 1
		
	if item_type == "life" and Global.player_lives < Global.total_lives:
		Global.player_lives = Global.player_lives + 1
	
	metrics.update_display()


func _on_NPC_update_metrics():
	metrics.update_display()
