extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@export var SPEED = 300
func _ready():
	animation.play("movement")
func _process(delta):
	var collision = move_and_collide(delta * velocity)
	if collision:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
