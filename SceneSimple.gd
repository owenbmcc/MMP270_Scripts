extends Node2D

export (NodePath) var player_path
onready var player = get_node(player_path)

var player_lives = 3

func game_over():
	player.dies()

func _on_player_hit(is_alive):
	player_lives -= 1
	if player_lives == 0 or not is_alive:
		game_over()
