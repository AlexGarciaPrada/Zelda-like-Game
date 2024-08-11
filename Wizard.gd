extends CharacterBody2D
var SPEED= 300
@onready var animation = $AnimatedSprite2D
@onready var shape = $CollisionShape2D
@onready var selfarea= $Area2D
@onready var weapond = $Weapon
@onready var weaponr = $Weapon2
@onready var weaponl = $Weapon3
@onready var weaponu = $Weapon4
@onready var hud = $Camera2D/Hud
@onready var camera = $Camera2D

@onready var fireball_scene = preload("res://Spells/FireBall/FireBall.tscn")
@onready var lure_scene = preload("res://Spells/Lure/Lure.tscn")
@onready var spine_scene = preload("res://Spells/Spines/Spines.tscn")
@onready var rotatefireball_scene = preload("res://Spells/RotatingFireball/RotatingFireball.tscn")
@onready var dialogue_scene = preload("res://Dialogues/Dialogues.tscn")
@onready var icon_spell = preload("res://HUD/Icon/Icon.tscn")
@onready var astralball_scene = preload("res://Spells/AstralBall/AstralBall.tscn")
@onready var health_scene = preload("res://Spells/Health/Health.tscn")
@onready var flare_scene = preload("res://Spells/Flare/Flare.tscn")

@export var knockback_time = 0.5
var knockback_timer = 0
@export var inmunity_time = 1
var inmunity_timer = 0


var life = 5
#await get_tree().create_timer(5).timeout Para acordarme
var enemies_in_area = []
var clue = "down"
var newdirection = Vector2(0,0)
var is_attacking = false
var is_invisible = false
var is_invisible_max = false
var is_spelling = false
var knockback_mode = false
var inmunity_mode=false
var inventory_mode = false
var knockback_speed = 300
@onready var area = $Area2D

func _physics_process(delta):
	if !Singleton.is_stopped:
		if knockback_mode:
			knockback_timer += delta
			_knockback()
			
			if is_not_acting():
				_movement()
				_speak()
				_spell_10()
				_spell_1()
				_spell_2()
				_spell_3()
				_spell_4()
				_spell_5()
				_spell_6()
				_spell_7()
				_spell_8()
				_spell_9()
				_short_attack()
				_show_inventory()
		if inmunity_mode:
			_inmunity()
			inmunity_timer += delta
		if is_not_acting() && !knockback_mode:
			_movement()
			_speak()
			_spell_10()
			_spell_1()
			_spell_2()
			_spell_3()
			_spell_4()
			_spell_5()
			_spell_6()
			_spell_7()
			_spell_8()
			_spell_9()
			_short_attack()
			_show_inventory()
		
	else:
		hud._change_page()
		_hide_inventory()
		
func _ready():
	if Singleton.hud != null:
		camera.remove_child(hud)
		camera.add_child(Singleton.hud.duplicate())
		hud = camera.get_child(0)
#-----------------------Acciones Básicas-----------------------
func _show_inventory():
	if Input.is_action_just_pressed("Inventory"):
		Singleton.is_stopped = true
		hud._show_inventory()
		inventory_mode = true
func _hide_inventory():
	if Input.is_action_just_pressed("Inventory"):
		Singleton.is_stopped = false
		inventory_mode = false
		hud._change_to_inventory()
		hud._hide_inventory()
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

func _short_attack():
	if Input.is_action_just_pressed("Attack") and is_not_previously_attacking() and is_not_acting:
		is_attacking = true
		if is_invisible:
			modulate.a8=255
			is_invisible = false
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

func _speak():
	if Input.is_action_just_pressed("Speak") && clue =="up":
		for npc in area.get_overlapping_areas():
			if npc.is_in_group("NPC"):
				var dialogue_instance = dialogue_scene.instantiate()
				dialogue_instance.dialogues = npc.get_parent().dialogues
				dialogue_instance.global_position = Vector2(0,125)
				animation.play("idle "+clue+" wizard")
				self.add_child(dialogue_instance)

#-----------------------Animaciones-----------------------
func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking = false
		_hide_weapons()
	elif is_spelling:
		is_spelling=false	
func is_not_acting():
	return !is_attacking and !is_spelling


#-----------------------Físicas-----------------------
func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy") :
		var enemy = area.get_parent()
		enemies_in_area.append(enemy)
		if !knockback_mode && !inmunity_mode && knockback_timer== 0:
			if !area.is_in_group("Cloud"):
				knockback_mode=true
				newdirection = (position - enemy.position).normalized()
			else:
				inmunity_mode = true
			
			life-=1	
				
		
func _inmunity():
	animation.modulate.r8=0
	if inmunity_timer>= inmunity_time:
		
		inmunity_mode = false
		inmunity_timer = 0
		animation.modulate.r8=255
		if !enemies_in_area.is_empty():
			if !area.is_in_group("Cloud"):
				knockback_mode=true
			else:
				inmunity_mode = true
			life-=1
			return
		return
		
func _knockback():
	velocity = newdirection * knockback_speed
	move_and_slide()
	selfarea.disable_mode=true
	if knockback_timer >= knockback_time:
		inmunity_mode = true
		knockback_timer = 0	
		knockback_mode = false
		
func _on_area_2d_area_exited(area):
	if area.is_in_group("Enemy"):
		enemies_in_area.erase(area.get_parent())

#----------------------- Hechizos-----------------------

func _lure_1():
	var lure_instance = lure_scene.instantiate()
	get_parent().add_child(lure_instance)
	lure_instance.global_position = global_position
	lure_instance.can_explode = false
	
func _lure_2():
	var lure_instance = lure_scene.instantiate()
	lure_instance.can_explode = true
	get_parent().add_child(lure_instance)
	lure_instance.global_position = global_position
	
func _fireball_1():
	var fireball_instance = fireball_scene.instantiate()
	get_parent().add_child(fireball_instance)
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
			
func _invisiblity_1():
	is_invisible = true
	animation.modulate.a8=100
	await get_tree().create_timer(5).timeout
	animation.modulate.a8=255
	is_invisible = false
	
func _invisiblity_2():
	is_invisible = true
	animation.modulate.a8=100
	await get_tree().create_timer(10).timeout
	animation.modulate.a8=255
	is_invisible = false
	
func _invisiblity_3():
	is_invisible_max = true
	animation.modulate.a8=100
	await get_tree().create_timer(10).timeout
	animation.modulate.a8=255
	is_invisible_max = false
func _spikes_1():
	var spine_up_instance = spine_scene.instantiate()
	var spine_down_instance = spine_scene.instantiate()
	spine_up_instance.rotate(-PI/2)
	spine_down_instance.rotate(PI/2)
	spine_up_instance.scale.y = -spine_up_instance.scale.y
	spine_up_instance.velocity = Vector2(0, -spine_up_instance.SPEED)
	spine_down_instance.velocity= Vector2(0, spine_down_instance.SPEED)
	get_parent().add_child(spine_up_instance)
	get_parent().add_child(spine_down_instance)
	spine_up_instance.global_position = weaponu.global_position
	spine_down_instance.global_position = weapond.global_position
	
func _spikes_2():
	for i in range(1,3):
		_spikes_1()
		if i == 1:
			await get_tree().create_timer(0.1).timeout
			
func _spikes_3():
	for i in range(1,3):
		var spine_up_instance = spine_scene.instantiate()
		var spine_left_instance = spine_scene.instantiate()
		var spine_down_instance = spine_scene.instantiate()
		var spine_right_instance = spine_scene.instantiate()
		spine_up_instance.rotate(-PI/2)
		spine_down_instance.rotate(PI/2)
		spine_left_instance.rotate(PI)
		spine_left_instance.scale.y = -spine_left_instance.scale.y
		spine_up_instance.scale.y = -spine_up_instance.scale.y
		spine_up_instance.velocity = Vector2(0, -spine_up_instance.SPEED)
		spine_down_instance.velocity= Vector2(0, spine_down_instance.SPEED)
		spine_left_instance.velocity= Vector2(-spine_left_instance.SPEED,0)
		spine_right_instance.velocity= Vector2(spine_left_instance.SPEED,0)
		get_parent().add_child(spine_up_instance)
		get_parent().add_child(spine_left_instance)
		get_parent().add_child(spine_down_instance)
		get_parent().add_child(spine_right_instance)
		spine_up_instance.global_position = weaponu.global_position
		spine_left_instance.global_position = weaponl.global_position
		spine_down_instance.global_position = weapond.global_position
		spine_right_instance.global_position = weaponr.global_position
		if i == 1:
			await get_tree().create_timer(0.1).timeout
func _health_1():
	var health = health_scene.instantiate()
	self.add_child(health)
func _rotatefireball_1():
	var rotatefireball_instance = rotatefireball_scene.instantiate()
	rotatefireball_instance.center = self
	get_parent().add_child(rotatefireball_instance) 

func _rotatefireball_2():
	var rotatefireball_instance = rotatefireball_scene.instantiate()
	rotatefireball_instance.center = self
	get_parent().add_child(rotatefireball_instance) 
	var rotatefireball_instance2 = rotatefireball_scene.instantiate()
	rotatefireball_instance2.center = self
	rotatefireball_instance2.angle = PI 
	get_parent().add_child(rotatefireball_instance2) 
	
func _rotatefireball_3():
	var rotatefireball_instance = rotatefireball_scene.instantiate()
	rotatefireball_instance.center = self
	rotatefireball_instance.angle = PI/2
	get_parent().add_child(rotatefireball_instance) 
	var rotatefireball_instance2 = rotatefireball_scene.instantiate()
	rotatefireball_instance2.center = self
	rotatefireball_instance2.angle = 7*PI/6
	get_parent().add_child(rotatefireball_instance2) 
	var rotatefireball_instance3 = rotatefireball_scene.instantiate()
	rotatefireball_instance3.center = self
	rotatefireball_instance3.angle = 11*PI/6
	get_parent().add_child(rotatefireball_instance3) 
func _flare_1():
	var flare_instance = flare_scene.instantiate()
	match clue:
		"up":
			flare_instance.position = weaponu.position+ Vector2(0,-30)
		"down":
			flare_instance.position= weapond.position + Vector2(0,30)
			flare_instance.rotate(PI)
		"right":
			flare_instance.position = weaponr.position + Vector2(30,0)
			flare_instance.rotate(PI/2)
		"left":
			flare_instance.position = weaponl.position+ Vector2(-30,0)
			flare_instance.rotate(-PI/2)
	add_child(flare_instance)
	
func _astralball_1():
	var astralball = astralball_scene.instantiate()
	get_parent().add_child(astralball)
	match clue:
		"right":
			astralball.position = weaponr.global_position
			astralball.rotate(PI/2)
			astralball.velocity = Vector2(astralball.SPEED, 0)
		"left":
			astralball.position = weaponl.global_position
			astralball.rotate(-PI/2)
			astralball.velocity = Vector2(-astralball.SPEED, 0)
		"up":
			astralball.position = weaponu.global_position
			astralball.velocity = Vector2(0, -astralball.SPEED)
		"down":
			astralball.position = weapond.global_position
			astralball.rotate(PI)
			astralball.velocity = Vector2(0,astralball.SPEED)
func _spell_1():
	if Input.is_action_just_pressed("1"):
		var icon = hud._get_spell_square(1)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())
		
func _spell_2():
	if Input.is_action_just_pressed("2"):
		var icon = hud._get_spell_square(2)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())

func _spell_3():
	if Input.is_action_just_pressed("3"):
		var icon = hud._get_spell_square(3)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())

func _spell_4():
	if Input.is_action_just_pressed("4"):
		var icon = hud._get_spell_square(4)
		print(icon)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())

func _spell_5():
	if Input.is_action_just_pressed("5"):
		var icon = hud._get_spell_square(5)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())

func _spell_6():
	if Input.is_action_just_pressed("6"):
		var icon = hud._get_spell_square(6)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())

func _spell_7():
	if Input.is_action_just_pressed("7"):
		var icon = hud._get_spell_square(7)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())

func _spell_8():
	if Input.is_action_just_pressed("8"):
		var icon = hud._get_spell_square(8)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())

func _spell_9():
	if Input.is_action_just_pressed("9"):
		var icon = hud._get_spell_square(9)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())
		
func _spell_10():
	if Input.is_action_just_pressed("0"):
		var icon = hud._get_spell_square(10)
		_sorcery(icon._get_element(),icon._get_spell(),icon._get_level())
		


#----------------------- Inventario Hechizos -----------------------
func _sorcery(element,spell,level):
	is_spelling=true
	if is_invisible:
		modulate.a8=255
		is_invisible = false
	animation.play("spell attack "+clue+ " wizard")
	velocity = Vector2(0,0)
	match element:
		"":
			hud._show_not_equipped_spell()
		"fire":
			match spell:
				"fireball":
					match level:
						1:
							_fireball_1()
				"rotatefireball":
					match level:
						1:
							_rotatefireball_1()
						2:	
							_rotatefireball_2()
						3:
							_rotatefireball_3()
				"flare":
					match  level:
						1:
							_flare_1()
		"nature":
			match spell:
				"spikes":
					match level:
						1:
							_spikes_1()
						2:
							_spikes_2()
						3:
							_spikes_3()
				"health":
					match level:
						1:
							_health_1()
		
		"dark":
			match spell:
				"invisible":
					match level:
						1:
							_invisiblity_1()
						2: 
							_invisiblity_2()
						3: 
							_invisiblity_3()
				"lure":
					match level:
						1:
							_lure_1()
						2:
							_lure_2()
				"astralball":
					match level:
						1:
							_astralball_1()

#----------------------- Funciones atmosféricas -----------------------
func _day_mode():
	hud._get_canva_modulate().color.a8 =0 

func _night_mode():
	hud._get_canva_modulate().color.a8= 100

func _activate_fog():
	hud._activate_fog()

func _desactivate_fog():
	hud._desactivate_fog()

func _cave_mode():
	hud._cave_mode()

#----------------------- Getters -----------------------
func _get_life():
	return self.life
