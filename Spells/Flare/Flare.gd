extends CharacterBody2D
@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("flare")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
