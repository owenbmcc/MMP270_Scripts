extends Area2D

# save position for player
# saved globally bc scene restarts if player game overs

# boolean to prevent setting more than once
var is_active = false

func _on_Checkpoint_body_entered(body):
	if not is_active:
		is_active = true
		$AnimatedSprite.play("Active")
		CheckpointsGlobal.update_spawn_position(position)
		
		# remove comment to play sfx
		# $ActivateSound.play()
