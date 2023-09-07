extends Control

# connect signals from UI buttons
# change scene to load a level or another scene
# quit to quit

@export_file var load_level_path
@export_file var instructions_path

func _on_StartButton_pressed():
	get_tree().change_scene_to_file(load_level_path)

func _on_InstructionsButton_pressed():
	get_tree().change_scene_to_file(instructions_path)

func _on_QuitButton_pressed():
	get_tree().quit()

# uncomment and connect signals for ui sfx

# func _on_button_down():
#	$ClickSound.play()

# func _on_mouse_entered():
#	$HoverSound.play()
