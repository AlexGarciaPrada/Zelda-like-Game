class_name Projectile2D
extends CharacterBody2D

@export var projectile_speed: float = 600.0


func launch(direction: Vector2) -> void:
	velocity = direction.normalized() * maxf(projectile_speed, 0.0)


func _physics_process(delta: float) -> void:
	if Singleton.is_stopped:
		return
	var collision := move_projectile(delta)
	if collision != null:
		_on_solid_collision(collision)


func move_projectile(delta: float) -> KinematicCollision2D:
	if velocity.is_zero_approx():
		return null
	return move_and_collide(velocity * maxf(delta, 0.0))


func _on_solid_collision(_collision: KinematicCollision2D) -> void:
	queue_free()
