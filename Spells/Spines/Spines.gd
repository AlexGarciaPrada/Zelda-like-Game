extends Projectile2D

@export var duration = 0.07
@onready var animation =$AnimatedSprite2D
@onready var selfarea = $Area2D
var area_entered = false
var has_collide = false
var remaining_duration: float = 0.0
func _ready():
	projectile_speed = 600.0
	animation.play("spine")
	remaining_duration = maxf(duration, 0.0)


func _physics_process(delta: float) -> void:
	if Singleton.is_stopped:
		return
	remaining_duration -= delta
	if remaining_duration <= 0.0:
		if not has_collide:
			queue_free()
		else:
			selfarea.set_deferred("monitoring", false)
		return
	super._physics_process(delta)

func _on_solid_collision(_collision: KinematicCollision2D) -> void:
	if area_entered or has_collide:
		return
	has_collide = true
	animation.play("explosion")
	var shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape != null:
		shape.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	animation.z_index = -1
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_2d_area_entered(area):
	if has_collide:
		return
	area_entered = true
	selfarea.set_deferred("monitoring", false)
	velocity = Vector2.ZERO
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if has_collide:
		queue_free()
