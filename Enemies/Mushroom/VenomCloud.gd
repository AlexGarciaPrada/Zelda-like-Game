extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("default")
	modulate.a8 = 255

func _process(delta):
	if !Singleton.is_stopped:
		modulate.a8 -= 1
		scale *= 1.001
		if modulate.a8 == 0:
			queue_free()
