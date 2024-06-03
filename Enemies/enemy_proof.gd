extends CharacterBody2D

@onready var player = $"../Wizard"
var speed = 200
var range = 400
var life = 1
var weapons_in_area = []

func _on_area_2d_area_entered(area):
	if area.is_in_group("Weapon"):
		weapons_in_area.append(area)

func _physics_process(delta):
	for weapon in weapons_in_area:
		if weapon.is_visible_in_tree():
			life -= 1
			weapons_in_area.erase(weapon)
			break
	if life < 1:
		queue_free()
	
	var distance_to_player = position.distance_to(player.position)
	if distance_to_player <= range && !player.is_invisible:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()


func _on_area_2d_area_exited(area):
	if area.is_in_group("Weapon"):
		weapons_in_area.erase(area)
