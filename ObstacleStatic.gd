extends Area2D

# obstacle that hurts player when colliding
# option to remove

@export var remove_on_collision : bool = false

func _body_entered(body):
	
	if $HitTimeout.is_stopped():
		body.enemy_collision() # call enemy collision func in player
		if remove_on_collision:
			queue_free()
		$HitTimeout.start()
	
		# remove comment to play sfx
		# $HitSound.play()
