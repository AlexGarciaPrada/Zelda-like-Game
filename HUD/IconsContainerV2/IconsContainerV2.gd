extends StaticBody2D

@export var number_label = ""
var icon_scene = preload("res://HUD/IconsV2/IconsV2.tscn")
@export var texture_path : String
@onready var this_texture = $TextureRect
var mouse_in = false
var element : String
var spell : String
var level : int
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = number_label
	if texture_path != null:
		$TextureRect.texture = load(texture_path)
	if this_texture.texture != null:
		_make_texture()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_in:
		if $TextureRect.texture != null:
			var icon = icon_scene.instantiate()
			icon.this_texture = $TextureRect.texture
			self.add_child(icon)
			if this_texture.texture != null:
				_make_texture()
			mouse_in = false

		
func _on_area_2d_mouse_entered():
	mouse_in = true
	

func _on_area_2d_mouse_exited():
	mouse_in = false

func _get_element():
	return element

func _get_spell():
	return spell

func _get_level():
	return level
	
func _make_texture():
	var texture_name = self.this_texture.texture.resource_path.get_file().get_basename()
	var parts = texture_name.split("_")
	element = parts[0]
	spell = parts[1]
	level = parts[2].to_int()
	
