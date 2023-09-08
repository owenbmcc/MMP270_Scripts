extends Area2D

# triggers dialog when player enters area
# dialog handled with dialogic plugin, installed through adding to addons folder
# https://github.com/coppolaemilio/dialogic/releases
# dialogic must be enabled in Project Settings > Plugins

# name of dialog has to match dialog/timeline in Dialogic
@export var dialog_name : = "Dialog Name"
@export var confirm_dialog_start : bool = true

var player : Player
var dialog = null
var player_entered : bool = false
var dialog_started : bool = false

signal update_metrics

func _ready():
	$Label.visible = false

func _process(_delta):
	if player_entered and not dialog_started:
		if Input.is_action_just_pressed("StartDialog") or not confirm_dialog_start:
			$Label.visible = false
			dialog_started = true
#			dialog = Dialogic.start(dialog_name)
#			Dialogic.set_variable("apple_count", Global.item_count)
#			add_child(dialog)
			$AnimatedSprite.play('Talk')
#			player.talk()
#			dialog.connect('timeline_end', self, 'end_dialog')
#			dialog.connect('dialogic_signal', self, 'update_resources')
			

func end_dialog(_param):
	$AnimatedSprite.play("Idle")
	player.move()

func update_resources(param):
	if param == 'add_fireball':
		print('Added a fireball!')
	if param == 'remove_apple':
		Global.item_count -= 1
	emit_signal('update_metrics')

# when player enters NPC area
func _on_body_entered(body):
	if confirm_dialog_start:
		$Label.visible = true
	player_entered = true
	player = body
	
# when player leaves
func _on_body_exited(body):
	remove_child(dialog)
	player_entered = false
	dialog_started = false
	$Label.visible = false
	end_dialog(null)
