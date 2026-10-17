extends Projectile2D

@onready var animation =$AnimatedSprite2D
@onready var selfarea = $Area2D
var has_collide = false
func _ready():
	projectile_speed = 600.0
	animation.play("fireball")

func _on_solid_collision(_collision: KinematicCollision2D) -> void:
	_explode()

func _explode() -> void:
	if has_collide:
		return
	animation.scale *= 0.6
	animation.play("explosion")
	var shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape != null:
		shape.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	has_collide = true
	selfarea.set_deferred("monitoring", false)
	selfarea.set_deferred("monitorable", false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_2d_area_entered(area):
	_explode()


func _on_animated_sprite_2d_animation_finished():
	if has_collide:
		queue_free()
