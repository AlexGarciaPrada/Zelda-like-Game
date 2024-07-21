extends StaticBody2D


var icon_scene = preload("res://HUD/IconsV2/IconsV2.tscn")
@export var texture_path : String
@onready var this_texture = $TextureRect
var mouse_in = false
@onready var border = $TextureRect3
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().texture_path != "":
		this_texture.texture = load(get_parent().texture_path)
	$Label.text = get_parent().number_label
	if this_texture.texture != null:
		_make_texture()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_in:
		if this_texture.texture != null:
			var icon = icon_scene.instantiate()
			icon.this_texture = $TextureRect.texture
			self.add_child(icon)
			if this_texture.texture != null:
				_make_texture()
			mouse_in = false
	if  this_texture.texture != null:
		border.visible = false
		
func _on_area_2d_mouse_entered():
	mouse_in = true
	

func _on_area_2d_mouse_exited():
	mouse_in = false
	
	

	
func _make_texture():
	var texture_name = self.this_texture.texture.resource_path.get_file().get_basename()
	var parts = texture_name.split("_")
	get_parent().element = parts[0]
	get_parent().spell = parts[1]
	get_parent().level = parts[2].to_int()
	
func _show_cursor():
	$Sprite2D.visible = true
	
func _hide_cursor():
	$Sprite2D.visible = false
