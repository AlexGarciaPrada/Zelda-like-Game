extends CharacterBody2D
@onready var this = $"."
@onready var explosion_collision = $Area2D/CollisionShape2D
@onready var area = $Area2D
@onready var collision = $CollisionShape2D
@onready var animation = $AnimatedSprite2D
var explosion = false
var can_explode : bool
var fuse_remaining: float = 3.0
func _ready():
	animation.play("idle")
	area.visible=false


func _physics_process(delta: float) -> void:
	if Singleton.is_stopped or explosion:
		return
	fuse_remaining -= delta
	if fuse_remaining > 0.0:
		return
	animation.scale = animation.scale * 1.2
	if can_explode:
		animation.play("explosion")
		area.visible=true
		explosion = true
	else: 
		queue_free()




func _on_animated_sprite_2d_animation_finished():
	if explosion:
		queue_free()
