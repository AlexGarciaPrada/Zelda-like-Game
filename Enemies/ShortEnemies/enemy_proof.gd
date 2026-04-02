class_name Enemy
extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animation = $AnimatedSprite2D
@onready var enemy_area = $Area2D
@onready var enemy_collision = $CollisionShape2D
@onready var death_particles = $DeathParticles # Referencia a las partículas

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

func _physics_process(delta):
	if Singleton.is_stopped or is_dying:
		return

	if is_knockback:
		_apply_knockback()
	else:
		_movement()

func _on_area_2d_area_entered(area):
	if is_dying or is_invulnerable:
		return
		
	if area.is_in_group("Weapon") and area.is_visible_in_tree():
		_take_damage(area)

func _take_damage(weapon):
	life -= 1
	
	knockback_direction = (global_position - player.global_position).normalized()


	if life <= 0:
		_die()
		
	else:
		_start_knockback()
		_flash_damage()
func _start_knockback():
	is_knockback = true
	is_invulnerable = true
	enemy_collision.disabled = true
	
	await get_tree().create_timer(knockback_duration).timeout
	
	is_knockback = false
	enemy_collision.disabled = false
	
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false

func _apply_knockback():
	velocity = knockback_direction * knockback_speed
	move_and_slide()

func _movement():
	var targets = get_objects_within_distance("Player", range)
	
	if targets.is_empty():
		animation.play("idle " + clue)
		return
	
	var objective = get_min_distance_obj(targets)
	if objective == null or is_player_in_area():
		velocity = Vector2.ZERO
		return
	
	var direction = global_position.direction_to(objective.global_position)
	velocity = direction * speed
	move_and_slide()
	
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

func _die():
	is_dying = true
	velocity = Vector2.ZERO
	enemy_collision.disabled = true
	enemy_area.monitoring = false
	enemy_area.monitorable = false
	
	animation.hide()
	$LifeBar.hide()
	
	death_particles.emitting = true
	
	enemy_area.queue_free()
	enemy_collision.queue_free()
	await get_tree().create_timer(death_particles.lifetime).timeout
	queue_free()

func _flash_damage():
	animation.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	animation.modulate = Color(1, 1, 1)

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
			
		var dist = global_position.distance_to(target.global_position)
		
		if dist < min_dist:
			if target == player:
				if player.is_invisible or player.is_invisible_max:
					continue
			min_dist = dist
			closest = target
	
	return closest

func is_player_in_area():
	for area in enemy_area.get_overlapping_areas():
		if area.get_parent().is_in_group("Player"):
			return true
	return false
