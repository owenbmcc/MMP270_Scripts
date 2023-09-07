extends Control

# metric that counts up from 0
# reference to Global value
@export var metric_name : String = "item"

# update value 
func update_display(value):
	$Label.text = str(value) # String(Global[item_name])


