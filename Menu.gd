extends Control

# used for multiple UI menus
# connect signals from UI buttons
# change scene to load a level or another scene
# quit to quit

# nodes
# Control (StartMenu, GameOverMenu, WinMenu, Instructions, etc)
	# Example layout, should be modified for specific design
	# CenterContainer
		# HBoxContainer
			# CenterContainer
				# TextureRect (Title, Graphic)
			# CenterContainer
				# VBoxContainer
				# TextureButton (StartButton)
				# TextureButton (QuitButton)
				# More buttons
	# AudioStreamPlayer (HoverSound)
	# AudioStreamPlayer (BackgroundMusic)

@export_file var load_level_path
@export_file var instructions_path

# connect pressed signal from start button
func _on_StartButton_pressed():
	get_tree().change_scene_to_file(load_level_path)

# connect pressed signal from instructions button
func _on_InstructionsButton_pressed():
	get_tree().change_scene_to_file(instructions_path)

# connect pressed signal from quit button
func _on_QuitButton_pressed():
	get_tree().quit()

# other buttons, add pressed signal and create new method

# uncomment and connect signals for ui sfx

# connect mouse_entered signal from any button for hover sound
# func _on_mouse_entered():
#	$HoverSound.play()
