extends StaticBody2D

@export var number_label = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = number_label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
