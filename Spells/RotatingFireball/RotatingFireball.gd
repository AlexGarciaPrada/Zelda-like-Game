
extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
var center = Node2D
@export var orbit_radius: float = 50.0
@export var orbit_speed: float = 3.0  # Radianes por segundo
var angle: float = 0.0

func _ready():
	animation.play("orbit")
	if center == null:
		print("Center node not assigned")
	else:
		# Initialize position based on the current angle
		update_position()

func _process(delta):
	if center != null:
		angle += orbit_speed * delta
		update_position()
		update_rotation()
		
func update_position():
	print(center)
	var x = center.position.x + orbit_radius * cos(angle)
	var y = center.position.y + orbit_radius * sin(angle)
	position = Vector2(x, y)

func update_rotation():
	var direction = Vector2(sin(angle),cos(angle))
	rotation = -direction.angle() +90



func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		queue_free()
