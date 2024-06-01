extends CharacterBody2D

@onready var player = %Wizard
var speed = 300
var range = 400



func _physics_process(delta):
	if sqrt((position.x-player.position.x)*(position.x-player.position.x)+(position.y-player.position.y)*(position.y-player.position.y)) <= range:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()
