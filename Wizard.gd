extends CharacterBody2D


const SPEED = 300.0
@onready var animation = $AnimatedSprite2D
func _physics_process(delta):
	_movement()
	
func _movement():
	var directionx = Input.get_axis("ui_left", "ui_right")
	var directiony = Input.get_axis("ui_up","ui_down")
	if directionx or directiony:
		animation.play("walk")
		velocity.x = directionx * SPEED
		velocity.y = directiony *SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y,0,SPEED)
		animation.play("idle")
#	_run()
	
	move_and_slide()
func _run():
	if Input.is_key_pressed(KEY_CTRL) :
		velocity = velocity*3
