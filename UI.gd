extends Camera2D

@onready var life_label= $VBoxContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()
	print(get_limit(SIDE_BOTTOM))
	print(get_limit(SIDE_RIGHT))
	print(get_limit(SIDE_TOP))
	print(get_limit(SIDE_LEFT))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_label.text= "Life: "+ str(get_parent().life)
