extends Area2D

var speed = 200
var velocity = Vector2()
var is_flying = true

func _ready():
	velocity = get_local_mouse_position().normalized() 

func _physics_process(delta):
	if is_flying:
		velocity.y += gravity * delta / speed
		position += velocity * delta * speed
		rotation = velocity.angle()
		
	if not $VisibilityNotifier2D.is_on_screen():
		queue_free()

func _on_Projectile_area_entered(area):
	# assume body is moving obstacle
	area.get_parent().hit()
	is_flying = false
	$AnimatedSprite.play('Hit')

func _on_Projectile_body_entered(body):
	is_flying = false
	$AnimatedSprite.play('Hit')
	
func _on_AnimatedSprite_animation_finished():
	if not is_flying:
		queue_free()
