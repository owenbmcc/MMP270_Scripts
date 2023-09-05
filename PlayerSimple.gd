extends KinematicBody2D

# controls player movement

# physics settings 
export var speed = 100

# "private" vars
var is_alive = true
var is_moving = true
var velocity = Vector2()

func _physics_process(delta):
	if is_alive:
		player_update(delta)
	
func player_update(delta):
	# assume player not moving
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("move_right"):
		velocity.x += speed # += is x = x + speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= speed
	if Input.is_action_pressed("move_down"):
		velocity.y += speed
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# set animation
	if velocity.length_squared() > 1 and is_moving:
		$AnimatedSprite.play("Walk")
	elif is_moving:
		$AnimatedSprite.play("Idle")

	if velocity.x > 0.1:
		$AnimatedSprite.flip_h = false
	
	if velocity.x < -0.1:
		$AnimatedSprite.flip_h = true

func talk():
	$AnimatedSprite.play('Talk')
	is_moving = false
	
func move():
	is_moving = true
