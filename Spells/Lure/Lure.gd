extends CharacterBody2D
@onready var this = $"."
@onready var explosion_collision = $Area2D/CollisionShape2D
@onready var area = $Area2D
@onready var collision = $CollisionShape2D
@onready var animation = $AnimatedSprite2D
var explosion = false
func _ready():
	animation.play("idle")
	area.visible=false
	await get_tree().create_timer(3).timeout
	animation.scale = animation.scale * 1.2
	animation.play("explosion")
	area.visible=true
	explosion = true




func _on_animated_sprite_2d_animation_finished():
	if explosion:
		queue_free()
