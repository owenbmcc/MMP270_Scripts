extends Control

# metric that counts up from 0
# can be its own scene/component or inside Metrics scene

# nodes
# Control (Metrics)
	# Control (Item to count) <- Script here
		# AnimatedSprite2D (or TextureRect/Sprite) icon image for metric
		# Label (to display count

# reference to Global value if tracking globally
@export var metric_name : String = "item"

# update value 
func update_display(value):
	$Label.text = str(value) # String(Global[item_name])
