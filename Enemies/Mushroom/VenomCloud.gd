extends CharacterBody2D
@onready var particle_system = $Node2D

func _ready():
	pass

func _process(delta):
	if particle_system.finished:
		queue_free()
