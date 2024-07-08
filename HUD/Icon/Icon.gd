extends TextureRect

@onready var label = $Label
@export var number = "1"
@onready var element =""
var spell = ""
var level = 0

func _ready():
	label.text = number
	if self.texture != null:
		_make_texture()
		_get_element()
		_get_spell()
		_get_level()
	
func _make_texture():
	var texture_name = self.texture.resource_path.get_file().get_basename()
	var parts = texture_name.split("_")
	element = parts[0]
	spell = parts[1]
	level = parts[2].to_int()
	
func _get_drag_data(position):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(30, 30)
	
	# Crear un nodo de Control para previsualizar el arrastre
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	# Ajustar la posición del preview para centrarlo en el ratón
	preview.set_position(Vector2(-15, -15))  # Ajustar según sea necesario para centrar
	
	set_drag_preview(preview)
	
	return texture


func _can_drop_data(position, data):
	return data is Texture2D

func _drop_data(at_position, data):
	texture = data
	_make_texture()
	
func _get_element():
	return element

func _get_spell():
	return spell

func _get_level():
	return level

