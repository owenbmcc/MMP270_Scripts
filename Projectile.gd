extends Area2D

var speed = 600
var velocity = Vector2.ZERO
var is_flying = true
var use_gravity : bool = false
var aim_to_mouse : bool = false

func _ready():
	if aim_to_mouse:
		velocity = get_local_mouse_position().normalized()

func set_direction(_aim_to_mouse, direction, enable_gravity):
	use_gravity = enable_gravity
	aim_to_mouse = _aim_to_mouse
	if not _aim_to_mouse:
		velocity.x = direction * speed
		velocity.y = -600 if enable_gravity else 0
		velocity = velocity.normalized()

func _physics_process(delta):
#	print('v ', velocity)
	if is_flying:
		if use_gravity:
			velocity.y += gravity * delta / speed
		position += velocity * delta * speed
		rotation = velocity.angle()
		
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		queue_free()

func _on_area_entered(area):
	print('proj area entered ', area)
	# assume body is moving obstacle
	area.get_parent().hit()
	is_flying = false
	$AnimatedSprite2D.play("Hit")

# hit tile map
func _on_body_entered(_body):
	is_flying = false
	$AnimatedSprite2D.play("Hit")

# remove projectile after hit
func _on_animation_finished():
	if not is_flying:
		queue_free()
