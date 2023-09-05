extends Area2D

# global variables
export var dialog_name = "Dialog Name"
var player = null
var dialog = null
var player_entered = false
var dialog_started = false
signal update_metrics

func _ready():
	$Label.visible = false

func _process(_delta):
	if player_entered and not dialog_started:
		if Input.is_action_just_pressed("ui_accept"):
			$Label.visible = false
			dialog_started = true
			dialog = Dialogic.start(dialog_name)
			Dialogic.set_variable("apple_count", Global.item_count)
			add_child(dialog)
			$AnimatedSprite.play('Talk')
			player.talk()
			dialog.connect('timeline_end', self, 'end_dialog')
			dialog.connect('dialogic_signal', self, 'update_resources')
			

func end_dialog(_param):
	$AnimatedSprite.play('Idle')
	player.move()

func update_resources(param):
	if param == 'add_fireball':
		print('Added a fireball!')
	if param == 'remove_apple':
		Global.item_count -= 1
	emit_signal('update_metrics')

func _on_NPC_body_entered(body):
	# when player enters NPC area
	$Label.visible = true
	player_entered = true
	player = body
	

func _on_NPC_body_exited(body):
	# when player leaves
	remove_child(dialog)
	player_entered = false
	dialog_started = false
	$Label.visible = false
	end_dialog(null)
	
