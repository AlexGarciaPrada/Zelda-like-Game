extends CharacterBody2D
var SPEED= 300
@onready var animation = $AnimatedSprite2D
@onready var shape = $CollisionShape2D
@onready var selfarea= $Area2D
@onready var weapond = $Weapon
@onready var weaponr = $Weapon2
@onready var weaponl = $Weapon3
@onready var weaponu = $Weapon4
@onready var fireball_scene = preload("res://FireBall.tscn")
@onready var lure_scene = preload("res://Lure.tscn")
@onready var dialogue_scene = preload("res://Dialogues/Dialogues.tscn")
@onready var life_label = $Camera2D/Label
@onready var dialogue = $Camera2D/Dialogues
var life = 10
#await get_tree().create_timer(5).timeout Para acordarme
var enemies_in_area = []
var clue = "down"
var current_frame=0
var newdirection = Vector2(0,0)
var is_attacking = false
var is_invisible = false
var is_spelling = false
var knockback_mode = false
var inmunity_mode=false
var knockback_speed = 300
@onready var area = $Area2D

func _physics_process(delta):
	if !Singleton.is_stopped:
		life_label.text = "Life:"+ str(life)
		if knockback_mode:
			_knockback()
			if is_not_acting():
				_movement()
				_fireball()
				_invisiblity()
				_lure()
				_short_attack()
		if inmunity_mode:
			_inmunity()
		if is_not_acting() && !knockback_mode:
			_movement()
			_fireball()
			_invisiblity()
			_lure()
			_short_attack()
			_speak()
func _inmunity():
	current_frame +=1
	if current_frame >= 60:
		selfarea.disable_mode=false
		inmunity_mode=false
		current_frame=0
		if !enemies_in_area.is_empty():
			knockback_mode=true
			life-=1
			return
		return
func _knockback():
	velocity = newdirection * knockback_speed
	move_and_slide()
	selfarea.disable_mode=true
	current_frame +=1
	if current_frame > 20:
		inmunity_mode = true
		knockback_mode=false
func _movement():
	var directionx = Input.get_axis("ui_left", "ui_right")
	var directiony = Input.get_axis("ui_up", "ui_down")
	
	if directionx != 0 or directiony != 0:
		if directiony > 0:
			animation.play("walk down wizard")
			clue = "down"
		elif directiony < 0:
			animation.play("walk up wizard")
			clue = "up"
		elif directionx > 0:
			animation.play("walk right wizard")
			clue = "right"
		elif directionx < 0:
			animation.play("walk left wizard")
			clue = "left"
		
		velocity.x = directionx * SPEED
		velocity.y = directiony * SPEED
		if directionx != 0 and directiony != 0:
			velocity /= 1.41
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation.play("idle " + clue+ " wizard")
	move_and_slide()
func _run():
	if Input.is_key_pressed(KEY_CTRL):
		velocity *= 3

func _short_attack():
	if Input.is_action_just_pressed("Attack") and is_not_previously_attacking() and is_not_acting:
		is_attacking = true
		animation.play("attack " + clue + " wizard")
		velocity = Vector2(0,0)
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
	elif is_spelling:
		is_spelling=false	

func _sorcery():
	is_spelling=true
	animation.play("spell attack "+clue+ " wizard")
	velocity = Vector2(0,0)
	
func _lure():
	if Input.is_action_just_pressed("Lure"):
		_sorcery()
		var lure_instance = lure_scene.instantiate()
		get_tree().get_current_scene().add_child(lure_instance)
		lure_instance.global_position = global_position
		var lure_animation = animation.duplicate()
		lure_instance.add_child(lure_animation)
		lure_instance.modulate.r=5
		lure_instance.modulate.g=0
		lure_instance.modulate.b=5
		lure_animation.play("idle "+ clue+" wizard")
		
func _fireball():
	if Input.is_action_just_pressed("FireBall"):
		_sorcery()
		var fireball_instance = fireball_scene.instantiate()
		get_parent().add_child(fireball_instance)
		fireball_instance.global_position = global_position # Set initial position to character's position
		match clue:
			"right":
				fireball_instance.position = weaponr.global_position
				fireball_instance.rotate(PI/2)
				fireball_instance.velocity = Vector2(fireball_instance.SPEED, 0)
			"left":
				fireball_instance.position = weaponl.global_position
				fireball_instance.rotate(-PI/2)
				fireball_instance.velocity = Vector2(-fireball_instance.SPEED, 0)
			"up":
				fireball_instance.position = weaponu.global_position
				fireball_instance.velocity = Vector2(0, -fireball_instance.SPEED)
			"down":
				fireball_instance.position = weapond.global_position
				fireball_instance.rotate(PI)
				fireball_instance.velocity = Vector2(0,fireball_instance.SPEED)
func _invisiblity():
	if Input.is_action_just_pressed("Invisiblity") && !is_invisible:
		_sorcery()
		is_invisible = true
		modulate.a8=100
		await get_tree().create_timer(5).timeout
		modulate.a8=255
		is_invisible = false
	
func is_not_acting():
	return !is_attacking and !is_spelling

	

func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy") :
		var enemy = area.get_parent()
		enemies_in_area.append(enemy)
		if !knockback_mode && !inmunity_mode:
			knockback_mode=true
			newdirection = (position - enemy.position).normalized()
			life-=1
		


func _on_area_2d_area_exited(area):
	if area.is_in_group("Enemy"):
		enemies_in_area.erase(area.get_parent())
func _speak():
	if Input.is_action_just_pressed("Speak") && clue=="up":
		for npc in area.get_overlapping_areas():
			if npc.is_in_group("NPC"):
				var dialogue_instance = dialogue_scene.instantiate()
				dialogue_instance.dialogues = npc.get_parent().dialogues
				dialogue_instance.global_position = Vector2(0,125)
				animation.play("idle "+clue+" wizard")
				self.add_child(dialogue_instance)
