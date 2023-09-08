extends CharacterBody2D
class_name Player

#	PlayerController uses the following inputs:
#		MoveUp, MoveDown, MoveRight, MoveLeft, Jump, Projectile
#	These are defined in Project > Project Settings > Input Map

# physics settings for player
@export var speed : int = 100
@export var use_slide : bool = false
@export var friction : int = 600
@export var use_gravity : bool = false
@export var jump_force : int = 400
@export var double_jump : bool = false
@export var use_wall_jump : bool = false
@export var projectile : PackedScene
@export var projectile_toward_mouse : bool = false
@export var projectile_gravity : bool = false
@export var y_limit : int = 0

# member vars 
var is_moving : bool = true
var is_alive : bool = true # to allow scene to run without character updating
#var velocity : Vector2 = Vector2()
var is_jumping : bool = false # track if jumping for landing sound
var jump_count : int = 0
var projectile_pause : bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal player_hit # signal if player is hit by obstacle
signal player_fall # player goes beneath game window

func _ready():
	if not is_on_floor():
		is_jumping = true
	if y_limit == 0:
		y_limit = get_viewport().size.y * 2

# this function will run every time the game engine updates physics
func _physics_process(delta):
	if is_alive:
		if is_moving:
			movement_update(delta)
	update_animation()

func movement_update(delta):
#	velocity.x = 0 # start by assuming player is not moving
	
	# capture user input
	var x_direction = Input.get_axis("MoveLeft", "MoveRight")
	if x_direction:
		velocity.x = x_direction * speed
	elif use_slide:
		if velocity.length() > (friction * delta):
			velocity.x -= velocity.normalized().x * (friction * delta)
		else:
			velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if not use_gravity:
		var y_direction = Input.get_axis("MoveUp", "MoveDown")
		if y_direction:
			velocity.y = y_direction * speed
		elif use_slide:
			if velocity.length() > (friction * delta):
				velocity.y -= velocity.normalized().y * (friction * delta)
			else:
				velocity.y = 0
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
	
	# spawn projectile
	if projectile:
		if Input.is_action_just_pressed("Projectile"):
			$AnimatedSprite2D.play("Projectile")
			if is_on_floor():
				is_moving = false
			spawn_projectile()

	# move player
	move_and_slide()
	
	if not use_gravity:
		return
		
	# apply gravity to player
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# detect landing before jump starts
	if is_jumping and (is_on_floor() or is_on_wall()):
		is_jumping = false
		jump_count = 0
		# remove comments to play sfx
		# $LandSound.play()
	
	# jump input
	var can_jump = is_on_floor() or (use_wall_jump and is_on_wall())
	if double_jump and jump_count < 2:
		if not can_jump:
			can_jump = true
	
	if Input.is_action_just_pressed("Jump") and can_jump:
		jump_count = jump_count + 1
		velocity.y -= jump_force
		is_jumping = true
		$AnimatedSprite2D.frame = 0
		# remove comments to play sfx
		# $JumpSound.play()
		
	# if player falls below screen
	if is_alive and position.y > y_limit:
		emit_signal("player_fall") # to scene manager
	
func update_animation():
	if not is_on_floor() and is_moving and use_gravity:
		$AnimatedSprite2D.play("Jump")
	elif velocity.length_squared() > 1 and is_moving:
		$AnimatedSprite2D.play("Walk")
	elif is_moving:
		$AnimatedSprite2D.play("Idle")

	# change sprite direction
	if velocity.x < -1:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 1:
		$AnimatedSprite2D.flip_h = false

func enemy_collision():
	is_moving = false # player movement suspended before determining state
	$AnimatedSprite2D.play('Hit')
	emit_signal("player_hit")

# after hit animation, test if player is still alive
func _on_animation_finished():
	# reset animation
	var a = $AnimatedSprite2D.animation
	if  a == "Projectile" or a == "Hit":
		is_moving = true

# called by scene manager if player out of lives
func die():
	is_alive = false
	$AnimatedSprite2D.play("Death")
	# remove comment to play sfx
	# $DeathSound.play()

func talk():
	$AnimateSprite2D.play("Talk")
	is_moving = false

func spawn_projectile():
	if projectile:
		var p = projectile.instantiate()
		# set direction of projectile in player direction
		p.set_direction(projectile_toward_mouse, -1 if $AnimatedSprite2D.flip_h else 1, projectile_gravity)
		p.position.x = self.position.x
		p.position.y = self.position.y
		owner.add_child(p)
