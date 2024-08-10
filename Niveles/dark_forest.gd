extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Wizard._night_mode()
	$Wizard._activate_fog()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
