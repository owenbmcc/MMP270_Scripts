extends KinematicBody2D

# physics settings for player
export var speed = 100
export var gravity = 800
export var jump_force = 400
export var wall_jump_enabled = false

export (PackedScene) var projectile
var is_moving = true

# "private" vars 
var is_alive = true # to allow scene to run without character updating
var velocity : Vector2 = Vector2()
var is_jumping = false # track if jumping for landing sound

signal player_hit # signal if player is hit by obstacle

func _ready():
	if not is_on_floor():
		is_jumping = true

# this function will run every time the game engine updates physics
func _physics_process(delta):
	if is_alive:
		player_update(delta)

func player_update(delta):
	velocity.x = 0 # start by assuming player is not moving
	
	# capture user input
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	
	# shoot projectile
	if Input.is_action_just_pressed("shoot"):
		$AnimatedSprite.play('Shoot')
		is_moving = false
		shoot()

	# apply player velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# apply gravity to player
	velocity.y += gravity * delta
	
	# detect landing before jump starts
	# remove comments to play sfx
	# if is_jumping and (is_on_floor() or is_on_wall()):
		# is_jumping = false
		# $LandSound.play()
	
	# jump input
	var can_jump = is_on_floor() or (wall_jump_enabled and is_on_wall())
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y -= jump_force
		is_jumping = true
		$AnimatedSprite.frame = 0
		
		# remove comments to play sfx
		# $JumpSound.play()
	
	# update animation
	
	if not is_on_floor() and is_moving:
		$AnimatedSprite.play("Jump")
	elif abs(velocity.x) > 1 and is_moving:
		$AnimatedSprite.play("Walk")
	elif is_moving:
		$AnimatedSprite.play("Idle")

	# change sprite direction
	if velocity.x < -1:
		$AnimatedSprite.flip_h = true
	if velocity.x > 1:
		$AnimatedSprite.flip_h = false
		
	# if player falls below screen
	if is_alive and position.y > get_viewport().size.y * 2:
		is_alive = false
		emit_signal("player_hit", is_alive) # player is dead -- change to remove life

func enemy_collision():
	is_alive = false # player movement suspended before determining state
	$AnimatedSprite.play('Hit')

# after hit animation, test if player is still alive
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'Hit':
		is_alive = true
		emit_signal("player_hit", is_alive) # don't know if player should die yet
	
	var a = $AnimatedSprite.animation
	if  a == 'Shoot' or a == 'Talk':
		is_moving = true

# called by scene manager if player out of lives
func dies():
	is_alive = false
	$AnimatedSprite.play('Dies')
	
	# remove comment to play sfx
	# $DiesSound.play()

func talk():
	$AnimateSprite.play('Talk')
	is_moving = false

func shoot():
	var p = projectile.instance()
#	p.set_direction(-1 if $AnimatedSprite.flip_h else 1)
	p.position.x = self.position.x
	p.position.y = self.position.y
	owner.add_child(p)
