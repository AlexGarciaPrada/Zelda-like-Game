extends Projectile2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var selfarea: Area2D = $Area2D

var center: Node2D
@export var orbit_radius: float = 50.0
@export var orbit_speed: float = 3.0
var angle: float = 0.0
var explosion: bool = false
var has_collide: bool = false
var area_entered: bool = false


func _ready() -> void:
	animation.play("orbit")
	if not is_instance_valid(center):
		queue_free()
		return
	update_position()


func _physics_process(delta: float) -> void:
	if Singleton.is_stopped or explosion:
		return
	if not is_instance_valid(center):
		queue_free()
		return

	angle = wrapf(angle + orbit_speed * delta, 0.0, TAU)
	var target_position := center.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius
	if delta > 0.0:
		velocity = (target_position - global_position) / delta
	var collision := move_projectile(delta)
	update_rotation()
	if collision != null and not area_entered:
		_explode()


func update_position() -> void:
	global_position = center.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius


func update_rotation() -> void:
	var direction := Vector2(sin(angle), cos(angle))
	rotation = -direction.angle() - PI / 2.0


func _explode() -> void:
	if explosion:
		return
	animation.scale = Vector2(0.7, 0.7)
	animation.play("explosion")
	var shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape != null:
		shape.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	has_collide = true
	explosion = true
	selfarea.set_deferred("monitoring", false)
	selfarea.set_deferred("monitorable", false)


func _on_area_2d_area_entered(_area: Area2D) -> void:
	if explosion:
		return
	area_entered = true
	_explode()


func _on_animated_sprite_2d_animation_finished() -> void:
	if explosion:
		queue_free()
