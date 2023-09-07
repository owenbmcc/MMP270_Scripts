extends Area2D

# Portal script, triggers "Entered" animation, loads new level

# pick scene/level to load
@export_file var load_level_path

# activate, then play animation, prevents multiple events
var is_entered : bool = false

# connect signal from portal Area2d
func _on_body_entered(_body):
	is_entered = true
	$AnimatedSprite2D.play("Entered")
	
	# remove comemnt to play sfx
	# $EnteredSound.play()

# connect singal from AnimatedSprite2D node
func _on_animation_finished():
	if is_entered:
		get_tree().change_scene_to_file(load_level_path)
