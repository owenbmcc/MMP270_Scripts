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

var player : CharacterBody2D

func _ready() -> void:
	$Label.visible = false

func _unhandled_input(_event : InputEvent) -> void:
	if trigger_on_enter:
		return
	if Input.is_action_just_pressed("StartDialog"):
		DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)
		return
	
func show_dialog() -> void:
	$Label.visible = false
	DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)
	
func show_label() -> void:
	$Label.visible = true

func _on_body_entered(body) -> void:
	if not player:
		player = body
	if trigger_on_enter:
		show_dialog()
	else:
		show_label()

func _on_body_exited(_body) -> void:
	$Label.visible = false
