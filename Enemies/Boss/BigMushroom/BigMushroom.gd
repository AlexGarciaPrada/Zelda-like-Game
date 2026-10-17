extends TopDownBody2D

@onready var player := get_tree().get_first_node_in_group("Player") as Node2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_area: Area2D = $Area2D
@onready var enemy_collision: CollisionShape2D = $CollisionShape2D

@export var speed: float = 150.0
@export var range: float = 250.0
@export var life: int = 2
@export var knockback_speed: float = 450.0
@export var knockback_duration: float = 0.25
@export var invulnerability_time: float = 0.4

var weapons_in_area: Array[Area2D] = []
var processed_weapons: Array[Area2D] = []
var clue := "down"
var is_dying := false
var knockback_mode := false
var invulnerability_remaining := 0.0
var knockback_remaining := 0.0
var damage_flash_remaining := 0.0
var newdirection := Vector2.ZERO


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (
		area.is_in_group("Weapon")
		and area.is_visible_in_tree()
		and not weapons_in_area.has(area)
		and not processed_weapons.has(area)
	):
		weapons_in_area.append(area)


func _physics_process(delta: float) -> void:
	if Singleton.is_stopped or is_dying:
		return

	if knockback_mode:
		knockback_remaining -= delta
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		move_at_current_velocity()
		if knockback_remaining <= 0.0:
			knockback_mode = false
			velocity = Vector2.ZERO
	else:
		_movement(delta)

	if invulnerability_remaining > 0.0:
		invulnerability_remaining -= delta
	if damage_flash_remaining > 0.0:
		damage_flash_remaining -= delta
		if damage_flash_remaining <= 0.0:
			animation.modulate = Color.WHITE
	_process_weapon_hits()
	_short_attack_area()


func _process_weapon_hits() -> void:
	for weapon in weapons_in_area.duplicate():
		if not is_instance_valid(weapon):
			weapons_in_area.erase(weapon)
			continue
		if not weapon.is_visible_in_tree():
			weapons_in_area.erase(weapon)
			continue
		if invulnerability_remaining > 0.0:
			continue
		weapons_in_area.erase(weapon)
		processed_weapons.append(weapon)
		_take_damage(weapon)
		break


func _take_damage(weapon: Area2D) -> void:
	life -= 1
	if life <= 0:
		_die()
		return

	invulnerability_remaining = maxf(invulnerability_time, 0.0)
	animation.modulate = Color(1.0, 0.35, 0.35)
	damage_flash_remaining = 0.1
	if weapon.is_in_group("ShortAttack") or weapon.is_in_group("Lure"):
		var origin := player.global_position if is_instance_valid(player) else weapon.global_position
		newdirection = global_position - origin
		if newdirection.is_zero_approx():
			newdirection = Vector2.DOWN
		newdirection = newdirection.normalized()
		apply_knockback_velocity(newdirection, knockback_speed)
		knockback_mode = true
		knockback_remaining = maxf(knockback_duration, 0.0)


func _on_area_2d_area_exited(area: Area2D) -> void:
	weapons_in_area.erase(area)
	processed_weapons.erase(area)


func _movement(delta: float) -> void:
	var objective := _get_target()
	if objective == null:
		animation.play("idle " + clue)
		move_in_direction(Vector2.ZERO, speed, delta)
		return

	var direction := global_position.direction_to(objective.global_position)
	if is_player_in_area():
		move_in_direction(Vector2.ZERO, speed, delta)
		return

	move_in_direction(direction, speed, delta)
	_update_animation(direction)


func _get_target() -> Node2D:
	var closest: Node2D
	var closest_distance := range
	for target in get_tree().get_nodes_in_group("Player"):
		if not is_instance_valid(target) or not target is Node2D:
			continue
		if target.get("is_invisible") or target.get("is_invisible_max"):
			continue
		var distance := global_position.distance_to(target.global_position)
		if distance < closest_distance:
			closest = target
			closest_distance = distance
	return closest


func _update_animation(direction: Vector2) -> void:
	if absf(direction.y) > absf(direction.x):
		if direction.y > 0.0:
			animation.play("walk down")
			clue = "down"
		else:
			animation.play("walk up")
			clue = "up"
	elif direction.x > 0.0:
		animation.play("walk right")
		clue = "right"
	else:
		animation.play("walk left")
		clue = "left"


func _short_attack_area() -> void:
	for weapon in enemy_area.get_overlapping_areas():
		if (
			weapon.is_in_group("Weapon")
			and weapon.is_visible_in_tree()
			and not weapons_in_area.has(weapon)
			and not processed_weapons.has(weapon)
		):
			weapons_in_area.append(weapon)


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_dying:
		queue_free()


func _die() -> void:
	is_dying = true
	velocity = Vector2.ZERO
	if is_instance_valid(enemy_collision):
		enemy_collision.set_deferred("disabled", true)
	if is_instance_valid(enemy_area):
		enemy_area.set_deferred("monitoring", false)
		enemy_area.set_deferred("monitorable", false)
	if animation.sprite_frames != null and animation.sprite_frames.has_animation("death"):
		animation.play("death")
	else:
		animation.hide()
		await get_tree().create_timer(0.25).timeout
		queue_free()


func is_player_in_area() -> bool:
	for area in enemy_area.get_overlapping_areas():
		if is_instance_valid(area) and is_instance_valid(area.get_parent()) and area.get_parent().is_in_group("Player"):
			return true
	return false
