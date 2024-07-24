extends StaticBody2D

@onready var this_texture = $TextureRect
@onready var border = $TextureRect3
@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = get_parent().number_label
# Called every frame. 'delta' is the elapsed time since the previous frame.


	
func _show_cursor():
	$Sprite2D.visible = true
	
func _hide_cursor():
	$Sprite2D.visible = false
	
func _gameplay_mode():
	label.position = Vector2(-14.371,19.162)
	label.scale = Vector2(0.9,0.9)
func _inventory_mode():
	label.position = Vector2(-15.569,-7.186)
	label.scale = Vector2(1,1)
