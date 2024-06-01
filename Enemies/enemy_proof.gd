extends CharacterBody2D

@onready var player = %Wizard
var speed = 300



func _physics_process(delta):
	velocity = position.direction_to(player.position) * speed
	move_and_slide()
