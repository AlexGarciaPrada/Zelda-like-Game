extends CharacterBody2D

@export var SPEED = 600
@export var duration = 0.2
@onready var animation =$AnimatedSprite2D
@onready var selfarea = $Area2D
var collision = false
func _ready():
	animation.play("spine")
	await get_tree().create_timer(duration).timeout
	queue_free()
func _physics_process(delta):
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_2d_area_entered(area):
	if !area.is_in_group("Player") && !area.is_in_group("Weapon"):
		selfarea.queue_free()
		velocity = Vector2(0,0)
		queue_free()

