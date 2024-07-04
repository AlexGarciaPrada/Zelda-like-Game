extends CharacterBody2D
@onready var this = $"."
@onready var explosion_collision = $Area2D/CollisionShape2D
@onready var area = $Area2D
@onready var collision = $CollisionShape2D
func _ready():
	area.visible=false
	await get_tree().create_timer(3).timeout
	area.visible=true
	queue_free()

