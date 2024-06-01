extends CharacterBody2D

const SPEED = 300.0
@onready var animation = $AnimatedSprite2D
@onready var shape = $CollisionShape2D
@onready var weapon1 =$Weapon
@onready var weapon2 =$Weapon2
@onready var weapon3 =$Weapon3
@onready var weapon4 =$Weapon4

var lastMovement = Vector2(1, 1)

func _physics_process(delta):
	_movement()
	_short_attack()
	
func _movement():
	var directionx = Input.get_axis("ui_left", "ui_right")
	var directiony = Input.get_axis("ui_up", "ui_down")
	
	if directionx != 0 or directiony != 0:
		animation.play("walk")
		velocity.x = directionx * SPEED
		velocity.y = directiony * SPEED
		lastMovement = Vector2(directionx, directiony)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y,0,SPEED)
		animation.play("idle")
	
	move_and_slide()

func _run():
	if Input.is_key_pressed(KEY_CTRL):
		velocity = velocity * 3
func _short_attack():
	if Input.is_action_just_pressed("Attack") and (is_not_previously_attacking()) :
		var maxdir = max(abs(lastMovement.x),abs(lastMovement.y))
		if sign(lastMovement.x)>=0 && maxdir==abs(lastMovement.x):
			weapon2.visible=true;
			await get_tree().create_timer(0.5).timeout
			weapon2.visible=false;
		if sign(lastMovement.x)<0 && maxdir==abs(lastMovement.x):
			weapon3.visible=true;
			await get_tree().create_timer(0.5).timeout
			weapon3.visible=false;	
		if sign(lastMovement.y)<0 && maxdir==abs(lastMovement.y):
			weapon4.visible=true;
			await get_tree().create_timer(0.5).timeout
			weapon4.visible=false;	
		if sign(lastMovement.y)>=0 && maxdir==abs(lastMovement.y):
			weapon1.visible=true;
			await get_tree().create_timer(0.5).timeout
			weapon1.visible=false;			
		await get_tree().create_timer(0.5).timeout
			
			
			
func is_not_previously_attacking():
	return (!weapon1.visible) and (!weapon2.visible) and (!weapon3.visible) and (!weapon4.visible)
