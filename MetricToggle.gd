extends Node

# metric that is either on or off based on a value number, like number of lives
export var metric_name = "player_lives"
export var value = 1 # value to compare 

# update on scene start
func _ready():
	update_display()
	
# update called by metrics manager
func update_display():
	self.visible = true if Global[metric_name] >= value else false
