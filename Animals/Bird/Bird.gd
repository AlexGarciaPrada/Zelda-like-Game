extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
var speed = 300
var is_flying = false
var rng = RandomNumberGenerator.new()
var direction = Vector2(0,0)
 

func _ready():
	rng.randomize() 
	direction = Vector2(rng.randf_range(-1, 1),rng.randf_range(-1, 1)).normalized()
	if direction.length_squared() == 0:
		direction = Vector2(1,1).normalized()
	animation.play("stop")
	velocity = speed * direction
	if direction.x > 0 :
		animation.flip_h = true
func _physics_process(delta):
	if is_flying:
		move_and_slide()

func _on_area_2d_area_entered(area):
	animation.play("fly")
	is_flying = true
