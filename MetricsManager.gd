extends Node

# get an array (list) of references to display nodes for each metric
export (Array, NodePath) var metrics_paths
var metrics = Array()

func _ready():
	# load the metrics from path
	for path in metrics_paths:
		var metric = get_node(path)
		metrics.push_front(metric)

# update display of each metric when state changes in game
func update_display():
	for metric in metrics:
		print(metric)
		metric.update_display()
