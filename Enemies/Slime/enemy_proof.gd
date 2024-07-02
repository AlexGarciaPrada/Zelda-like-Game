extends CharacterBody2D

@onready var player = $"../Wizard"
var speed = 150
var range = 250
var life = 2
var weapons_in_area = []
var clue ="down"
var is_dying = false
var knockback_mode = false
@onready var animation= $AnimatedSprite2D
@onready var enemyarea=$Area2D
@onready var enemycollision= $CollisionShape2D
var knockback_speed = 450
var current_frame = 0
var newdirection = Vector2(0,0)

func _on_area_2d_area_entered(area):
	if area.is_in_group("Weapon"):
		weapons_in_area.append(area)

func _physics_process(delta):
	if !Singleton.is_stopped:
		if knockback_mode:
			velocity = newdirection * knockback_speed
			collision_layer =2
			move_and_slide()
			current_frame +=1
			if current_frame == 15:
				knockback_mode=false
				collision_layer=6
				enemycollision.disabled=false
				current_frame=0
		elif !is_dying:
			_movement()	
			for weapon in weapons_in_area:
				if weapon.is_visible_in_tree():
					life -= 1
					weapons_in_area.erase(weapon)
					if (weapon.is_in_group("ShortAttack") or weapon.is_in_group("Lure")) && life > 0:
						knockback_mode= true
						newdirection = (position - player.position).normalized()
						current_frame=0
					if life >=1:
						animation.modulate.r=255
						await get_tree().create_timer(0.5).timeout
						animation.modulate.r=1
					break
				else:
					weapons_in_area.erase(weapon)	
			_short_attack_area()		
			if life < 1:
				if enemycollision!=null:
					enemycollision.queue_free()
				if enemycollision != null:
					enemyarea.queue_free()
				is_dying=true
				animation.play("death down")
		
	
	


func _on_area_2d_area_exited(area):
	if area.is_in_group("Weapon"):
		weapons_in_area.erase(area)
		
func _movement():
	var targets = get_objects_within_distance("Player",range)
	if !targets.is_empty():
		var objective = get_min_distance_obj(targets)
		if objective != null:
			var direction= position.direction_to(objective.position)	
			velocity = direction * speed
			move_and_slide()
			if abs(direction.y) > abs(direction.x):
				if direction.y > 0:
					animation.play("walk down")
					clue = "down"
				elif direction.y < 0 :
					animation.play("walk up")
					clue = "up"
			else:
				if direction.x > 0 :
					animation.play("walk right")
					clue = "right"
				elif direction.x < 0:
					animation.play("walk left")
					clue = "left"	
func _short_attack_area():
	if enemyarea != null && enemyarea.has_overlapping_areas && !is_dying: 
		for weapon in enemyarea.get_overlapping_areas():
			if (weapon.is_in_group("ShortAttack") or weapon.is_in_group("Lure")) && !weapons_in_area.has(weapon) && !weapon.is_visible_in_tree() && !weapon == null:
				weapons_in_area.append(weapon)

func _on_animated_sprite_2d_animation_finished():
	if is_dying:
		queue_free()
func get_objects_within_distance(group_name, distance):
	var nodes_in_group = get_tree().get_nodes_in_group(group_name)
	var objects_within_distance = []
	for node in nodes_in_group:
		var node_distance = global_position.distance_to(node.global_position)
		if node_distance <= distance:
			objects_within_distance.append(node)
	return objects_within_distance

func get_min_distance_obj(ObjectList):
	var result = range
	var object
	for target in ObjectList:
		if result >= position.distance_to(target.global_position) && !is_dying:
			if target == player:
				if !player.is_invisible:
					result= position.distance_to(target.global_position)
					object= player
			else:
				result= position.distance_to(target.global_position)
				object= target
	return object
