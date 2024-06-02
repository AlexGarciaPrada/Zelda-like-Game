extends CharacterBody2D

@onready var player = $"../Wizard"
var speed = 200
var range = 400
var life = 1


func _on_area_2d_area_entered(area):
	if area.is_in_group("Weapon"):
		life -= 1

func _physics_process(delta):
	if life < 1:
		queue_free()
	
	var distance_to_player = position.distance_to(player.position)
	if distance_to_player <= range:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()

