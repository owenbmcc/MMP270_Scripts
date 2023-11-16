extends Area2D


# on activation flip is_active and then play animation
var is_active = false
signal on_activate # signal to scene manager
var signal_sent = false # prevent sending signal multiple times

func _on_body_entered(_body):
	if not is_active:
		is_active = true
		$AnimatedSprite2D.play("Entered")

func _on_animation_finished():
	if is_active and not signal_sent:
		signal_sent = true
		emit_signal("on_activate")
