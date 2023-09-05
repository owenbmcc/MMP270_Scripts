extends Area2D

# support multiple "type" of items, 
# need to duplicate the original scene instance and replace animations
export var item_type = "apple"

# "private" vars
signal item_collected # send signal to metrics or other places
var item_is_collected = false # prevents item from being collected during exit animation

# when player body enters item area -- area2d does not cause collisions
func _on_Item_body_entered(_body):
	
	# this assumes layer/mask setup only allows collisions with player
	if not item_is_collected:
		# prevent multiple collections during animation
		item_is_collected = true
		$AnimatedSprite.play('Collected')
		$AnimatedSprite.frame = 0 # make sure it plays from beginning
		
		# emit signal to add to global item count
		emit_signal('item_collected', item_type)
		
		# remove comment to play sfx
		# $CollectedSound.play()

# when the collected animation finishing play, remove the item
func _on_AnimatedSprite_animation_finished():
	if item_is_collected:
		queue_free()
