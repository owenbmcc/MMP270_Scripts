extends Label

# metric that counts up from 0

# reference to Global value
export var item_name = "item_count"

# display on ready, also when metrics update
func _ready():
	update_display()
	
# update value from Global
func update_display():
	text = String(Global[item_name])


