extends CharacterBody2D

@onready var player = $"../Wizard"
var speed = 200
var range = 400
var life = 2
var weapons_in_area = []
var clue ="down"
@onready var animation= $AnimatedSprite2D
@onready var enemyarea=$Area2D
func _on_area_2d_area_entered(area):
	if area.is_in_group("Weapon"):
		weapons_in_area.append(area)

func _physics_process(delta):
	for weapon in weapons_in_area:
		if weapon.is_visible_in_tree():
			life -= 1
			weapons_in_area.erase(weapon)
			if life >=1:
				animation.modulate.r=255
				await get_tree().create_timer(0.5).timeout
				animation.modulate.r=1
			break
		else:
			weapons_in_area.erase(weapon)	
	if life < 1:
		queue_free()
	_short_attack_area()	
	_movement()	
	
	


func _on_area_2d_area_exited(area):
	if area.is_in_group("Weapon"):
		weapons_in_area.erase(area)
		
func _movement():
	var distance_to_player = position.distance_to(player.position)
	if distance_to_player <= range && !player.is_invisible:
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
func _short_attack_area():
	for weapon in enemyarea.get_overlapping_areas():
		if weapon.is_in_group("ShortAttack") && !weapons_in_area.has(weapon) && !weapon.is_visible_in_tree():
			weapons_in_area.append(weapon)
	
