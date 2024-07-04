extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var area = $Area2D
var weapons_in_area = []
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("idle")
func _physics_process(delta):
	for weapon in weapons_in_area:
		if weapon.is_visible_in_tree():
			animation.play("roto")
			if collision != null:
				collision.queue_free()
			if area != null:
				area.queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("Weapon") :
		weapons_in_area.append(area)


func _on_area_2d_area_exited(area):
	weapons_in_area.erase(area)
