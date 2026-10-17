class_name TopDownBody2D
extends CharacterBody2D

@export var acceleration: float = 1400.0
@export var deceleration: float = 1800.0


func move_in_direction(direction: Vector2, speed: float, delta: float) -> void:
	var normalized_direction := direction.normalized()
	var target_velocity := normalized_direction * maxf(speed, 0.0)
	var rate := acceleration if not normalized_direction.is_zero_approx() else deceleration
	velocity = velocity.move_toward(target_velocity, rate * maxf(delta, 0.0))
	move_and_slide()


func move_at_current_velocity() -> void:
	move_and_slide()


func apply_knockback_velocity(direction: Vector2, speed: float) -> void:
	var normalized_direction := direction.normalized()
	if normalized_direction.is_zero_approx():
		normalized_direction = Vector2.DOWN
	velocity = normalized_direction * maxf(speed, 0.0)
