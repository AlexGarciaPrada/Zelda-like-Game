extends CharacterBody2D

const SPEED = 300.0
@onready var animation = $AnimatedSprite2D
@onready var shape = $CollisionShape2D
@onready var weapon1 = $Weapon
@onready var weapon2 = $Weapon2
@onready var weapon3 = $Weapon3
@onready var weapon4 = $Weapon4
var clue = "abajo"
var is_attacking = false

func _physics_process(delta):
	_movement()
	_short_attack()

func _movement():

	
	var directionx = Input.get_axis("ui_left", "ui_right")
	var directiony = Input.get_axis("ui_up", "ui_down")
	
	if directionx != 0 or directiony != 0:
		if directiony > 0:
			animation.play("walk abajo")
			clue = "abajo"
		elif directiony < 0:
			animation.play("walk arriba")
			clue = "arriba"
		elif directionx > 0:
			animation.play("walk derecha")
			clue = "derecha"
		elif directionx < 0:
			animation.play("walk izquierda")
			clue = "izquierda"
		
		velocity.x = directionx * SPEED
		velocity.y = directiony * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation.play("idle " + clue)
	
	move_and_slide()

func _run():
	if Input.is_key_pressed(KEY_CTRL):
		velocity = velocity * 3

func _short_attack():
	if Input.is_action_just_pressed("Attack") and is_not_previously_attacking():
		is_attacking = true
		
		match clue:
			"derecha":
				weapon2.visible = true
			"izquierda":
				weapon3.visible = true
			"arriba":
				weapon4.visible = true
			"abajo":
				weapon1.visible = true
		
		await get_tree().create_timer(0.2).timeout
		_hide_weapons()
		is_attacking = false

func _hide_weapons():
	weapon1.visible = false
	weapon2.visible = false
	weapon3.visible = false
	weapon4.visible = false

func is_not_previously_attacking():
	return !weapon1.visible and !weapon2.visible and !weapon3.visible and !weapon4.visible

