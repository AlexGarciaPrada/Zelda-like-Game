extends TextureRect

@onready var label = $Label
@export var number = "1"

func _ready():
	label.text = number

func _get_drag_data(position):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 0
	preview_texture.size = Vector2(30, 30)
	
	# Crear un nodo de Control para previsualizar el arrastre
	var preview = Control.new()
	preview.add_child(preview_texture)
	 # Obtener la posición global del ratón y convertirla a coordenadas locales del preview
	#var local_position = preview.global_to_local(mouse_position)
	set_drag_preview(preview)
	preview_texture.position = get_global_mouse_position()-preview.position
	
	return texture

func _can_drop_data(position, data):
	return data is Texture2D

func _drop_data(at_position, data):
	texture = data


