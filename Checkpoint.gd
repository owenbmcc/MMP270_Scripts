extends Area2D

# save position for player
# saved globally bc scene restarts if player game overs

# nodes
	# Area2D (Checkpoint)
		# AnimatedSprite2D
		# CollisionShape2D
		# AudioStreamPlayer (ActivateSound) (Optional)

# boolean to prevent setting more than once
var is_active : bool = false
signal checkpoint_activated

func _on_body_entered(_body):
	if not is_active:
		is_active = true
		$AnimatedSprite2D.play("Active")
#		CheckpointsGlobal.update_spawn_position(position)
		emit_signal("checkpoint_activated", position)
		
		# remove comment to play sfx
		# $ActivateSound.play()
