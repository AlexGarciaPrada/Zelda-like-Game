class_name Enemy
extends TopDownBody2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animation = $AnimatedSprite2D
@onready var enemy_area = $Area2D
@onready var enemy_collision = $CollisionShape2D
@onready var death_particles = get_node_or_null("DeathParticles")
@onready var life_bar = get_node_or_null("LifeBar")

@export var speed := 150
@export var range := 250
@export var life := 2
@export var knockback_speed := 450
@export var knockback_duration := 0.2
@export var invulnerability_time := 0.4

var clue := "down"
var is_dying := false
var is_knockback := false
var is_invulnerable := false
var knockback_direction := Vector2.ZERO
var knockback_remaining := 0.0
var invulnerability_remaining := 0.0
var damage_flash_remaining := 0.0

func _physics_process(delta: float) -> void:
	if Singleton.is_stopped or is_dying:
		return

	if is_knockback:
		knockback_remaining -= delta
		_apply_knockback(delta)
		if knockback_remaining <= 0.0:
			is_knockback = false
			velocity = Vector2.ZERO
	else:
		_movement(delta)

	if is_invulnerable:
		invulnerability_remaining -= delta
		if invulnerability_remaining <= 0.0:
			is_invulnerable = false
	if damage_flash_remaining > 0.0:
		damage_flash_remaining -= delta
		if damage_flash_remaining <= 0.0 and is_instance_valid(animation):
			animation.modulate = Color.WHITE

func _on_area_2d_area_entered(area):
	if is_dying or is_invulnerable:
		return
		
	if area.is_in_group("Weapon") and area.is_visible_in_tree():
		_take_damage(area)

func _take_damage(weapon):
	life -= 1
	
	var origin: Vector2 = player.global_position if is_instance_valid(player) else weapon.global_position
	knockback_direction = global_position - origin
	if knockback_direction.is_zero_approx():
		knockback_direction = Vector2.DOWN
	knockback_direction = knockback_direction.normalized()


	if life <= 0:
		_die()
		
	else:
		_start_knockback()
		_flash_damage()
func _start_knockback() -> void:
	is_knockback = true
	is_invulnerable = true
	knockback_remaining = maxf(knockback_duration, 0.0)
	invulnerability_remaining = knockback_remaining + maxf(invulnerability_time, 0.0)
	apply_knockback_velocity(knockback_direction, knockback_speed)

func _apply_knockback(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_at_current_velocity()

func _movement(delta: float) -> void:
	var targets = get_objects_within_distance("Player", range)
	
	if targets.is_empty():
		animation.play("idle " + clue)
		move_in_direction(Vector2.ZERO, speed, delta)
		return
	
	var objective = get_min_distance_obj(targets)
	if objective == null or is_player_in_area():
		animation.play("idle " + clue)
		move_in_direction(Vector2.ZERO, speed, delta)
		return
	
	var direction = global_position.direction_to(objective.global_position)
	move_in_direction(direction, speed, delta)
	
	_update_animation(direction)

func _update_animation(direction):
	if abs(direction.y) > abs(direction.x):
		if direction.y > 0:
			animation.play("walk down")
			clue = "down"
		else:
			animation.play("walk up")
			clue = "up"
	else:
		if direction.x > 0:
			animation.play("walk right")
			clue = "right"
		else:
			animation.play("walk left")
			clue = "left"

func _die() -> void:
	is_dying = true
	velocity = Vector2.ZERO
	enemy_collision.set_deferred("disabled", true)
	enemy_area.set_deferred("monitoring", false)
	enemy_area.set_deferred("monitorable", false)
	if is_instance_valid(life_bar):
		life_bar.hide()
	if is_instance_valid(death_particles) and death_particles is GPUParticles2D:
		animation.hide()
		death_particles.emitting = true
		await get_tree().create_timer(death_particles.lifetime).timeout
	elif animation.sprite_frames != null and animation.sprite_frames.has_animation("death"):
		animation.play("death")
		await get_tree().create_timer(_death_animation_duration()).timeout
	else:
		animation.hide()
		await get_tree().create_timer(0.25).timeout
	queue_free()


func _death_animation_duration() -> float:
	var frames: SpriteFrames = animation.sprite_frames
	if frames != null and frames.has_animation("death"):
		var fps := frames.get_animation_speed("death")
		if fps > 0.0:
			return float(frames.get_frame_count("death")) / fps
	return 0.3

func _flash_damage() -> void:
	animation.modulate = Color(1.0, 0.35, 0.35)
	damage_flash_remaining = 0.1

func get_objects_within_distance(group_name, distance):
	var result = []
	for node in get_tree().get_nodes_in_group(group_name):
		if global_position.distance_to(node.global_position) <= distance:
			result.append(node)
	return result

func get_min_distance_obj(object_list):
	var min_dist = range
	var closest = null
	
	for target in object_list:
		if is_dying:
			continue
		if not is_instance_valid(target) or not target is Node2D:
			continue
		var dist = global_position.distance_to(target.global_position)
		if dist >= min_dist:
			continue
		if target == player:
			if player.is_invisible or player.is_invisible_max:
				continue
		min_dist = dist
		closest = target
	
	return closest

func is_player_in_area():
	for area in enemy_area.get_overlapping_areas():
		if is_instance_valid(area) and is_instance_valid(area.get_parent()) and area.get_parent().is_in_group("Player"):
			return true
	return false
