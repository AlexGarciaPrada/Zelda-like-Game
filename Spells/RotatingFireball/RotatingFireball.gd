
extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
var center = Node2D
@export var orbit_radius: float = 50.0
@export var orbit_speed: float = 3.0  # Radianes por segundo
@onready var area = $Area2D
var angle: float = 0.0
var explosion = false

func _ready():
	animation.play("orbit")
	if center == null:
		print("Center node not assigned")
	else:
		# Initialize position based on the current angle
		update_position()

func _process(delta):
	if center != null && !explosion:
		angle += orbit_speed * delta
		update_position()
		update_rotation()
		
func update_position():
	var x = center.position.x + orbit_radius * cos(angle)
	var y = center.position.y + orbit_radius * sin(angle)
	position = Vector2(x, y)

func update_rotation():
	var direction = Vector2(sin(angle),cos(angle))
	rotation = -direction.angle() +90



func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		animation.scale = Vector2(0.7,0.7)
		velocity = Vector2(0,0)
		animation.play("explosion")
		explosion = true
		area.queue_free()


func _on_animated_sprite_2d_animation_finished():
	if explosion:
		queue_free()
