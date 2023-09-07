extends CharacterBody2D

# basic moving enemy
# dies on player hit
# attack player in attack box, deals one damage
# detect player to start moving
# use separate layers for each collider
# Death and Attack animations can't loop

# rename main CollisionShade2D to Collider for Platform Checker to change directions on platform edge

# editor settings
@export var is_moving : bool = true
@export var speed : int = 50
@export var stay_on_platform : bool = true
@export var direction : int = -1 # 1 for right, -1 for left
@export var activate_on_player_detect : bool = false # begins moving when player is within area

# member vars
var is_alive : bool = true
var horizontal_move : bool = true
var temp_speed : int = speed
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.flip_h = direction == 1 # match animation to direction
	
	# move floor check in front of collider
	$PlatformChecker.position.x = direction * $Collider.shape.radius
	
	# stop movement if waiting for player detect
	if activate_on_player_detect:
		horizontal_move = false

func _physics_process(_delta):
	if is_moving and is_alive:
		movement_update()

func movement_update():
	if stay_on_platform:
#		print('wall ', is_on_wall())
#		print('colliding ', $PlatformChecker.is_colliding())
		if is_on_wall() or not $PlatformChecker.is_colliding():
			direction = direction * -1 # switch direction
			$AnimatedSprite2D.flip_h = direction == 1 # match animation to direction
			$PlatformChecker.position.x = direction * $Collider.shape.radius
			$HitBox.position.x = $HitBox.position.x * -1
			$Attack.position.x = $Attack.position.x * -1
			
	velocity.y += gravity
	
	if is_on_floor() and horizontal_move:
		velocity.x = speed * direction
	
	move_and_slide()
	
	if abs(velocity.x) > 0.1:
		$AnimatedSprite2D.play("Walk")

# hit by player or projectile
func hit():
	is_alive = false
	$AnimatedSprite2D.play("Death")
	
	# remove comment to play sfx
	# $DeathSound.play()

# if player jump on head or another part, hits with projectile
func _on_HitBox_body_entered(_body):
	if is_alive:
		hit()

# area that harms/kills player
func _on_Attack_body_entered(body):
	
	if is_alive and body.is_alive and $HitTimeout.is_stopped():
		$AnimatedSprite2D.play("Attack")
		is_moving = false # stop moving to attack player
		body.enemy_collision() # call enemy collision func in player
		$HitTimeout.start()
		
		# remove comment to play sfx
		# $HitSound.play()

# area that detect player is nearby
func _on_Detect_body_entered(_body):
	if is_alive:
		if activate_on_player_detect:
			horizontal_move = true

func _on_animation_finished():
	
	# if dead, remove object
	if not is_alive:
		queue_free()
		
	# resume moving after attack
	if $AnimatedSprite2D.animation == "Attack":
		is_moving = true
