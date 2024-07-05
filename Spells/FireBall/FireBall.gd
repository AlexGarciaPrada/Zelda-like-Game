extends CharacterBody2D

const SPEED = 600
@onready var animation =$AnimatedSprite2D
@onready var selfarea = $Area2D
var collision = false
func _ready():
	animation.play("fireball")
func _physics_process(delta):
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		animation.scale = animation.scale * 0.6
		animation.play("explosion")
		selfarea.queue_free()
		velocity = Vector2(0,0)
		collision=true


func _on_animated_sprite_2d_animation_finished():
	if collision:
		queue_free()
