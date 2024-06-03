extends CharacterBody2D

const SPEED = 600
@onready var animation =$AnimatedSprite2D
func _ready():
	animation.play("fireball")
func _physics_process(delta):
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
