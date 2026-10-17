extends TopDownBody2D

@export var move_speed: float = 180.0
@onready var animation = $AnimatedSprite2D
@onready var weapond = $Weapon
@onready var weaponr = $Weapon2
@onready var weaponl = $Weapon3
@onready var weaponu = $Weapon4
@onready var hud = $Camera2D/Hud
@onready var camera = $Camera2D
@onready var hit_particles = $HitParticles
@onready var dialogue_scene = preload("res://Dialogues/Dialogues.tscn")

@export var knockback_time: float = 0.5
var knockback_timer: float = 0.0
@export var inmunity_time: float = 1.0
var inmunity_timer: float = 0.0


var life = 5
var max_life = 10
#await get_tree().create_timer(5).timeout Para acordarme
var enemies_in_area: Array[Area2D] = []
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
var invisibility_remaining: float = 0.0
@onready var area = $Area2D

func _physics_process(delta: float) -> void:
	if Singleton.is_stopped:
		hud._change_page()
		_hide_inventory()
		return
	_update_invisibility(delta)

	if knockback_mode:
		knockback_timer += delta
		_knockback()
		if knockback_timer >= knockback_time:
			knockback_timer = 0.0
			knockback_mode = false
			inmunity_mode = true
			inmunity_timer = 0.0
		return

	if inmunity_mode:
		_inmunity(delta)
	if knockback_mode:
		_knockback()
		return
	if is_not_acting():
		_movement(delta)
		_speak()
		for i in range(10):
			_spell_n(i)
		_short_attack()
		_show_inventory()
		
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
func _movement(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not direction.is_zero_approx():
		if absf(direction.y) > absf(direction.x) and direction.y > 0.0:
			animation.play("walk down wizard")
			clue = "down"
		elif absf(direction.y) > absf(direction.x) and direction.y < 0.0:
			animation.play("walk up wizard")
			clue = "up"
		elif direction.x > 0.0:
			animation.play("walk right wizard")
			clue = "right"
		else:
			animation.play("walk left wizard")
			clue = "left"
	else:
		animation.play("idle " + clue+ " wizard")
	move_in_direction(direction, move_speed, delta)

func _short_attack():
	if Input.is_action_just_pressed("Attack") and is_not_previously_attacking() and is_not_acting():
		is_attacking = true
		if is_invisible:
			_cancel_invisibility()
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
func _on_area_2d_area_entered(source_area: Area2D) -> void:
	if not source_area.is_in_group("Enemy"):
		return
	if not enemies_in_area.has(source_area):
		enemies_in_area.append(source_area)
	if not knockback_mode and not inmunity_mode:
		_receive_hit(source_area)


func _receive_hit(source_area: Area2D) -> void:
	life = maxi(life - 1, 0)
	hit_particles.restart()
	if source_area != null and not source_area.is_in_group("Cloud"):
		var away_direction := global_position - source_area.global_position
		if away_direction.is_zero_approx():
			away_direction = _facing_direction()
		newdirection = away_direction.normalized()
		apply_knockback_velocity(newdirection, knockback_speed)
		knockback_mode = true
		knockback_timer = 0.0
	else:
		velocity = Vector2.ZERO
		inmunity_mode = true
		inmunity_timer = 0.0


func _inmunity(delta: float) -> void:
	inmunity_timer += delta
	animation.modulate.r = 0.45 if int(inmunity_timer * 12.0) % 2 == 0 else 1.0
	if inmunity_timer < inmunity_time:
		return

	inmunity_mode = false
	inmunity_timer = 0.0
	animation.modulate.r = 1.0
	for source_area in enemies_in_area:
		if is_instance_valid(source_area) and source_area.is_in_group("Enemy") and not source_area.is_in_group("Cloud"):
			_receive_hit(source_area)
			return
	for source_area in enemies_in_area:
		if is_instance_valid(source_area) and source_area.is_in_group("Enemy"):
			_receive_hit(source_area)
			return


func _knockback() -> void:
	move_at_current_velocity()


func _on_area_2d_area_exited(source_area: Area2D) -> void:
	if is_instance_valid(source_area) and source_area.is_in_group("Enemy"):
		enemies_in_area.erase(source_area)


func _facing_direction() -> Vector2:
	match clue:
		"up": return Vector2.UP
		"down": return Vector2.DOWN
		"left": return Vector2.LEFT
		"right": return Vector2.RIGHT
	return Vector2.DOWN

#----------------------- Hechizos-----------------------

func _spell_n(number: int) -> void:
	if not Input.is_action_just_pressed(str(number)):
		return
	var icon = hud._get_spell_square(number)
	if icon != null:
		_sorcery(icon._get_element(), icon._get_spell(), icon._get_level())


func _sorcery(element, spell, level) -> void:
	var spell_element := StringName(str(element))
	var spell_id := StringName(str(spell))
	var spell_level := int(level)
	if not SpellRegistry.has_spell(spell_element, spell_id, spell_level):
		hud._show_not_equipped_spell()
		return

	is_spelling = true
	if is_invisible:
		_cancel_invisibility()
	animation.play("spell attack " + clue + " wizard")
	velocity = Vector2.ZERO
	if not SpellRegistry.cast(spell_element, spell_id, spell_level, self):
		is_spelling = false
		hud._show_not_equipped_spell()


func get_facing_direction() -> Vector2:
	match clue:
		"up": return Vector2.UP
		"down": return Vector2.DOWN
		"left": return Vector2.LEFT
		"right": return Vector2.RIGHT
	return Vector2.DOWN


func get_weapon_position(direction: Vector2) -> Vector2:
	if absf(direction.y) >= absf(direction.x):
		return weaponu.global_position if direction.y < 0.0 else weapond.global_position
	return weaponr.global_position if direction.x > 0.0 else weaponl.global_position


func spawn_spell_projectile(scene: PackedScene, direction: Vector2, spawn_position: Vector2) -> Projectile2D:
	if scene == null or not is_instance_valid(get_parent()):
		return null
	var projectile := scene.instantiate() as Projectile2D
	if projectile == null:
		push_error("Un hechizo intentó crear una escena que no deriva de Projectile2D.")
		return null
	get_parent().add_child(projectile)
	projectile.global_position = spawn_position
	projectile.rotation = Vector2.UP.angle_to(direction)
	projectile.launch(direction)
	return projectile


func spawn_spell_effect(scene: PackedScene, direction: Vector2, spawn_position: Vector2) -> Node2D:
	if scene == null or not is_instance_valid(get_parent()):
		return null
	var effect := scene.instantiate() as Node2D
	if effect == null:
		return null
	get_parent().add_child(effect)
	effect.global_position = spawn_position
	effect.rotation = Vector2.UP.angle_to(direction)
	return effect


func set_invisibility(level: int) -> void:
	invisibility_remaining = 5.0 if level == 1 else 10.0
	is_invisible = true
	is_invisible_max = level >= 3
	animation.modulate.a = 100.0 / 255.0


func _update_invisibility(delta: float) -> void:
	if invisibility_remaining <= 0.0:
		return
	invisibility_remaining -= delta
	if invisibility_remaining <= 0.0:
		_cancel_invisibility()


func _cancel_invisibility() -> void:
	invisibility_remaining = 0.0
	animation.modulate.a = 1.0
	is_invisible = false
	is_invisible_max = false


func heal(amount: int = 1) -> void:
	life = mini(life + maxi(amount, 0), max_life)

#----------------------- Funciones atmosféricas -----------------------
func _day_mode():
	hud._day_mode()

func _night_mode():
	hud._night_mode()

func _activate_fog():
	hud._activate_fog()

func _desactivate_fog():
	hud._desactivate_fog()

func _cave_mode():
	hud._cave_mode()
	$Light.visible = true

#----------------------- Getters -----------------------
func _get_life():
	return self.life
