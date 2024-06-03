extends CharacterBody2D

const SPEED = 300.0
@onready var animation = $AnimatedSprite2D
@onready var shape = $CollisionShape2D
@onready var weapon1 = $Weapon
@onready var weapon2 = $Weapon2
@onready var weapon3 = $Weapon3
@onready var weapon4 = $Weapon4
var clue = "down"
var is_attacking = false



func _physics_process(delta):
	if !is_attacking:
		_movement()
	_short_attack()
	move_and_slide()

func _movement():
	var directionx = Input.get_axis("ui_left", "ui_right")
	var directiony = Input.get_axis("ui_up", "ui_down")
	
	if directionx != 0 or directiony != 0:
		if directiony > 0:
			animation.play("walk down")
			clue = "down"
		elif directiony < 0:
			animation.play("walk up")
			clue = "up"
		elif directionx > 0:
			animation.play("walk right")
			clue = "right"
		elif directionx < 0:
			animation.play("walk left")
			clue = "left"
		
		velocity.x = directionx * SPEED
		velocity.y = directiony * SPEED
		if directionx !=0 && directiony!=0:
			velocity=velocity/1.41
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation.play("idle " + clue)

func _run():
	if Input.is_key_pressed(KEY_CTRL):
		velocity = velocity * 3

func _short_attack():
	if Input.is_action_just_pressed("Attack") and is_not_previously_attacking() and !is_attacking:
		is_attacking = true
		animation.play("attack " + clue)
		match clue:
			"right":
				weapon2.visible = true
			"left":
				weapon3.visible = true
			"up":
				weapon4.visible = true
			"down":
				weapon1.visible = true

func _hide_weapons():
	weapon1.visible = false
	weapon2.visible = false
	weapon3.visible = false
	weapon4.visible = false

func is_not_previously_attacking():
	return !weapon1.visible and !weapon2.visible and !weapon3.visible and !weapon4.visible

func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking = false
		_hide_weapons()

