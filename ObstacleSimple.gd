extends Area2D

export var frame_number = 0 # default frame, change frame in sprite

func _ready():
	$Sprite.frame = frame_number

func _on_Obstacle_body_entered(body):
	body.enemy_collision() # call enemy collision func in player
	
	# remove comment to play sfx
	# $HitSound.play()
