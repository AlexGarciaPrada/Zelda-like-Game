extends CharacterBody2D

@export var SPEED = 600
@export var duration = 0.07
@onready var animation =$AnimatedSprite2D
@onready var selfarea = $Area2D
var area_entered = false
var has_collide = false
func _ready():
	animation.play("spine")
	await get_tree().create_timer(duration).timeout
	if !has_collide:
		queue_free()
	else:
		selfarea.queue_free()

func _physics_process(delta):
	position += velocity * delta
	var collision = move_and_collide(velocity * delta)
	if collision && !area_entered:
		has_collide = true
		animation.play("explosion")
		if $CollisionShape2D != null:
			$CollisionShape2D.queue_free()
		velocity = Vector2(0,0)
		animation.z_index = -1
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_2d_area_entered(area):
		area_entered= true
		selfarea.queue_free()
		velocity = Vector2.ZERO
		queue_free()
