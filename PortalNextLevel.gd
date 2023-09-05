extends Area2D

# property to choose scene in different levels/instances
export(String, FILE, "*.tscn") var load_level_path

# on activation flip is_active and then play animation
var is_active = false

func _on_PortalNextLevel_body_entered(body):
	is_active = true
	$AnimatedSprite.play("Active")
	
	# remove comment to play sfx
	# $ActivateSound.play()

func _on_AnimatedSprite_animation_finished():
	if is_active:
		get_tree().change_scene(load_level_path)	
