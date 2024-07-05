extends Control

@onready var label = $Panel/ColorRect/Label
@export var label_text = "1"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = label_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
