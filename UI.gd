extends Camera2D

@onready var life_label= $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_label.text= "Life: "+ str(6)
