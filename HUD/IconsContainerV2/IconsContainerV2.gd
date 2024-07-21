extends StaticBody2D

@onready var this_texture = $TextureRect
@onready var border = $TextureRect3
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = get_parent().number_label
# Called every frame. 'delta' is the elapsed time since the previous frame.


	
func _show_cursor():
	$Sprite2D.visible = true
	
func _hide_cursor():
	$Sprite2D.visible = false
