extends CharacterBody2D

@onready var player = $"../Wizard"
var speed = 200
var range = 200
var life = 1
var weapons_in_area = []
var clue ="down"
var is_dying = false
var knockback_mode = false
@onready var animation= $AnimatedSprite2D
@onready var enemyarea=$Area2D
var knockback_speed = 450
var current_frame = 0
var newdirection = Vector2(0,0)

func _on_area_2d_area_entered(area):
	if area.is_in_group("Weapon"):
		queue_free()

func _physics_process(delta):
	print(weapons_in_area)
	if knockback_mode:
		velocity = newdirection * knockback_speed
		move_and_slide()
		current_frame +=1
		if current_frame == 15:
			knockback_mode=false
			current_frame=0
	elif !is_dying:
		for weapon in weapons_in_area:
			if weapon.is_visible_in_tree():
				life -= 1
				weapons_in_area.erase(weapon)
				if weapon.is_in_group("ShortAttack") && life > 0:
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
		_movement()			
		if life < 1:
			is_dying=true
			#Quitar esto cuando haya animación de muerte
			queue_free()
			animation.play("death down")
		
	
	


func _on_area_2d_area_exited(area):
	if area.is_in_group("Weapon"):
		weapons_in_area.erase(area)
		
func _movement():
	var distance_to_player = position.distance_to(player.position)
	if distance_to_player <= range && !player.is_invisible && !is_dying:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()
		var direction= position.direction_to(player.position)	
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
	else:
		animation.play("idle")
func _short_attack_area():
	for weapon in enemyarea.get_overlapping_areas():
		if weapon.is_in_group("ShortAttack") && !weapons_in_area.has(weapon) && !weapon.is_visible_in_tree():
			weapons_in_area.append(weapon)

func _on_animated_sprite_2d_animation_finished():
	if is_dying:
		queue_free()
