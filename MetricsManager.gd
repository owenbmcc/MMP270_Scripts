extends Node

# updates visual display based on global items
# item strings have to match Global items/collectibles
# add on top of regular level

# nodes
# Control (Metrics) <- Script here
	# Add control node for each metric (examples below)
	# Control (Items, Coins, Points)
		# AnimatedSprite2D
		# Label
	# Control (Life, anything with set number)
		# AnimatedSprite2D (Life1)
		# AnimatedSprite2D (Life2)
		# AnimatedSprite2D (Life3)

# in level
# Node2D (Level 1)
	# CanvasLayer (UI)
		# Metrics (instance)


# get an array (list) of references to display nodes for each metric
@export var metrics_paths : Array[NodePath]
var metrics = Array()

func _ready():
	for path in metrics_paths:
		metrics.append(get_node(path))
	# load the metrics from path
	update()

func update():
	for metric in metrics:
		var value = 0
		if Global.props.has(metric.metric_name):
			value = Global.props[metric.metric_name]
		metric.update_display(value)
