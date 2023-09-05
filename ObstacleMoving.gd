extends KinematicBody2D

# editor settings
export var is_moving = true
export var speed = 50
export var stay_on_platform = true
export var direction = -1 # 1 for right, -1 for left
export var activate_on_player_detect = false # begins moving when player is within area

# 'private' vars
var velocity = Vector2()
var is_alive = true
var horizontal_move = true
var temp_speed = speed
var gravity = 100 # export this?

func _ready():
	$AnimatedSprite.flip_h = direction == 1 # match animation to direction
	
	# move floor check in front of collider
	$PlatformCheck.position.x = direction * $Collider.shape.get_radius()
	
	# stop movement if waiting for player detect
	if activate_on_player_detect:
		horizontal_move = false

func _physics_process(delta):
	if is_moving and is_alive:
		movement_update(delta)

func movement_update(delta):
	if stay_on_platform:
		if is_on_wall() or not $PlatformCheck.is_colliding():
			direction = direction * -1 # switch direction
			$AnimatedSprite.flip_h = direction == 1 # match animation to direction
			$PlatformCheck.position.x = direction * $Collider.shape.get_radius()
			
	velocity.y += gravity
	
	if is_on_floor() and horizontal_move:
		velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if abs(velocity.x) > 0.1:
		$AnimatedSprite.play('Walk')
		

# collisions -- assumes layer masks are set up

# hit by player or projectile
func hit():
	is_alive = false
	$AnimatedSprite.play('Dies')
	
	# remove comment to play sfx
	$DiesSound.play()

# if player jump on head or another part, hits with projectile
func _on_Hit_body_entered(body):
	if is_alive:
		hit()

# area that harms/kills player
func _on_Attack_body_entered(body):
	if is_alive and body.is_alive:
		$AnimatedSprite.play('Attack')
		is_moving = false # stop moving to attack player
		body.enemy_collision() # call enemy collision func in player
		
		# remove comment to play sfx
		$HitSound.play()

# area that detect player is nearby
func _on_Detect_body_entered(body):
	if is_alive:
		if activate_on_player_detect:
			horizontal_move = true

func _on_AnimatedSprite_animation_finished():
	
	# if dead, remove object
	if not is_alive:
		queue_free()
		
	# resume moving after attack
	if $AnimatedSprite.animation == 'Attack':
		is_moving = true
