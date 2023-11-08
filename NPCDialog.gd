extends Area2D

# works with Dialogue Manager plugin to provide dialog for NPC character
# set area collision to interact with Player only
# Nodes
	# Area2D : NPC
		# AnimatedSprite2D
		# CollisionShape2D
		# Label

@export var dialog_resource : DialogueResource
@export var dialog_start : String = "start"
@export var trigger_on_enter : bool = true

# custom dialog balloon
@export var dialog_balloon : PackedScene

var is_player_entered : bool = false

func _ready() -> void:
	$Label.visible = false

func _unhandled_input(_event : InputEvent) -> void:
	if not is_player_entered:
		return
	if trigger_on_enter:
		return
	if Input.is_action_just_pressed("StartDialog"):
		if dialog_balloon:
			var balloon: Node = dialog_balloon.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(dialog_resource, dialog_start)
		else:
			DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)
		return
	
func show_dialog() -> void:
	$Label.visible = false
	DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)
	
func show_label() -> void:
	$Label.visible = true

func _on_body_entered(body) -> void:
	is_player_entered = true
	await get_tree().physics_frame
	body.input_vector = Vector2.ZERO
	if trigger_on_enter:
		show_dialog()
	else:
		show_label()

func _on_body_exited(_body) -> void:
	is_player_entered = false
	$Label.visible = false
