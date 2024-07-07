extends TextureRect

@onready var label = $Label
@export var number = "1"
var element =""
var spell = ""

func _ready():
	
	label.text = number
	if self.texture != null:
		var texture_name = self.texture.resource_path.get_file().get_basename()
		var parts = texture_name.split("_")
		element = parts[0]
		spell = parts[1]

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

func _input(event):
	if event is InputEventMouseMotion:
		var preview = get_drag_preview()
		if preview:
			preview.set_position(event.position + Vector2(-15, -15))


func _can_drop_data(position, data):
	return data is Texture2D

func _drop_data(at_position, data):
	texture = data


