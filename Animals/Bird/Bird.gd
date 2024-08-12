extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
var speed = 500
var is_flying = false
var direction = Vector2 (randf_range(-1,1),randf_range(-1,0))

func _ready():
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
