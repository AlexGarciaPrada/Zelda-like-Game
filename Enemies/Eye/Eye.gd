
class_name Eye
extends Enemy

@export var cooldown = 3
var time = cooldown
var direction : Vector2
var is_attacking = false
@onready var energyball_scene = preload("res://Enemies/Eye/EnergyBall.tscn")

func _physics_process(delta: float) -> void:
	if not Singleton.is_stopped and not is_dying:
		time += delta
	super._physics_process(delta)
func _on_animated_sprite_2d_animation_finished():
	if is_dying:
		animation.visible=false
		queue_free()
	elif is_attacking:
		_energyball(direction)
		is_attacking= false

func _energyball(shot_direction: Vector2) -> void:
	var energyball := energyball_scene.instantiate() as Projectile2D
	if energyball == null:
		return
	get_parent().add_child(energyball)
	energyball.global_position = global_position + shot_direction * 28.0
	energyball.launch(shot_direction)
	
func _movement(delta: float) -> void:
	var targets = get_objects_within_distance("Player",range)
	var objective = get_min_distance_obj(targets)
	if objective == null:
		animation.play("idle " + clue)
		move_in_direction(Vector2.ZERO, speed, delta)
		return

	direction = global_position.direction_to(objective.global_position)
	if is_attacking:
		move_in_direction(Vector2.ZERO, speed, delta)
		return
	_update_animation(direction)

	if time >= cooldown:
		is_attacking = true
		time = 0.0
		velocity = Vector2.ZERO
		animation.play("attack " + clue)
		move_at_current_velocity()
		return

	if is_player_in_area():
		move_in_direction(Vector2.ZERO, speed, delta)
	else:
		move_in_direction(direction, speed, delta)
