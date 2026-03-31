
class_name Eye
extends Enemy

@export var cooldown = 3
var time = cooldown
var direction : Vector2
var is_attacking = false
@onready var energyball_scene = preload("res://Enemies/Eye/EnergyBall.tscn")

func _physics_process(delta):
	super._physics_process(delta)
	time += delta
	_try_attack()
func _on_animated_sprite_2d_animation_finished():
	if is_dying:
		animation.visible=false
		queue_free()
	elif is_attacking:
		_energyball(direction)
		is_attacking= false

func _energyball(direction: Vector2):
	var energyball = energyball_scene.instantiate()
	match clue:
		"up":
			energyball.position = self.position + Vector2(0,-28)
		"down":
			energyball.position = self.position + Vector2(0,28)
		"left":
			energyball.position = self.position + Vector2(-28,0)
		"right":
			energyball.position = self.position + Vector2(28,0)
			
	energyball.velocity = energyball.SPEED * direction
	get_parent().add_child(energyball)
	
func _movement():
	var targets = get_objects_within_distance("Player",range)
	if !targets.is_empty():
		var objective = get_min_distance_obj(targets)
		if objective != null && !is_player_in_area():
			direction= position.direction_to(objective.position)	
			if time >= cooldown:
				animation.play("attack "+ clue)
				is_attacking = true
				time = 0
			velocity = direction * speed
			move_and_slide()
			if !is_attacking:
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
		animation.play("walk "+ clue)	
		
func _try_attack():
	if time < cooldown or is_dying:
		return false
	
	is_attacking = true
	time = 0
	animation.play("attack " + clue)
	
	return true
