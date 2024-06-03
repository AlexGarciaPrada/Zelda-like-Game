extends CharacterBody2D
var SPEED= 300
@onready var animation = $AnimatedSprite2D
@onready var shape = $CollisionShape2D
@onready var weapond = $Weapon
@onready var weaponr = $Weapon2
@onready var weaponl = $Weapon3
@onready var weaponu = $Weapon4
@onready var fireball_scene = preload("res://FireBall.tscn")

var clue = "down"
var is_attacking = false

func _physics_process(delta):
	if !is_attacking:
		_movement()
	_short_attack()
	_fireball()
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
		if directionx != 0 and directiony != 0:
			velocity /= 1.41
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation.play("idle " + clue+ " wizard")

func _run():
	if Input.is_key_pressed(KEY_CTRL):
		velocity *= 3

func _short_attack():
	if Input.is_action_just_pressed("Attack") and is_not_previously_attacking() and !is_attacking:
		is_attacking = true
		animation.play("attack " + clue)
		match clue:
			"right":
				weaponr.visible = true
			"left":
				weaponl.visible = true
			"up":
				weaponu.visible = true
			"down":
				weapond.visible = true

func _hide_weapons():
	weaponr.visible = false
	weaponl.visible = false
	weaponu.visible = false
	weapond.visible = false

func is_not_previously_attacking() -> bool:
	return !weaponr.visible and !weaponl.visible and !weaponu.visible and !weapond.visible

func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking = false
		_hide_weapons()

func _fireball():
	if Input.is_action_just_pressed("FireBall"):
		var fireball_instance = fireball_scene.instantiate()
		get_parent().add_child(fireball_instance)
		fireball_instance.global_position = global_position # Set initial position to character's position
		match clue:
			"right":
				fireball_instance.position = weaponr.global_position
				fireball_instance.velocity = Vector2(fireball_instance.SPEED, 0)
			"left":
				fireball_instance.position = weaponl.global_position
				fireball_instance.velocity = Vector2(-fireball_instance.SPEED, 0)
			"up":
				fireball_instance.position = weaponu.global_position
				fireball_instance.velocity = Vector2(0, -fireball_instance.SPEED)
			"down":
				fireball_instance.position = weapond.global_position
				fireball_instance.velocity = Vector2(0,fireball_instance.SPEED)

