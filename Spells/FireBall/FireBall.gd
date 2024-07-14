extends CharacterBody2D

const SPEED = 600
@onready var animation =$AnimatedSprite2D
@onready var selfarea = $Area2D
var has_collide = false
var area_entered = false
func _ready():
	animation.play("fireball")
func _physics_process(delta):
	position += velocity * delta
	var collision = move_and_collide(velocity * delta)
	if collision && !area_entered:
		animation.scale = animation.scale * 0.6
		animation.play("explosion")
		if $CollisionShape2D != null:
			$CollisionShape2D.queue_free()
		velocity = Vector2(0,0)
		has_collide = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_2d_area_entered(area):
	area_entered = true
	animation.scale = animation.scale * 0.6
	animation.play("explosion")
	selfarea.queue_free()
	velocity = Vector2(0,0)


func _on_animated_sprite_2d_animation_finished():
	if has_collide:
		queue_free()
