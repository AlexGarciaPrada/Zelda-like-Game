extends TextureRect

@onready var label = $Label
@export var number = ""
@onready var element =""
@export var is_Inventory = true
@onready var equip_labeL= $Label2
var is_Equipped = false
var initial_position = Vector2()
var spell = ""
var level = 0

func _ready():
	initial_position = position
	label.text = number
	if self.texture != null:
		_make_texture()
		_get_element()
		_get_spell()
		_get_level()
		if is_Inventory:
			pass
			#_set_is_Equipped()
			#_visual_is_Equipped()
	
func _make_texture():
	var texture_name = self.texture.resource_path.get_file().get_basename()
	var parts = texture_name.split("_")
	element = parts[0]
	spell = parts[1]
	level = parts[2].to_int()

func _get_drag_data(position):
	print(position)
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(30, 30)

	# Crear un nodo de Control para previsualizar el arrastre
	var preview = Control.new()
	preview.add_child(preview_texture)
	preview_texture.position = position

	set_drag_preview(preview)
	if is_Inventory:
		get_parent().get_parent().get_parent()._set_visual_equipped()
	return preview_texture.texture

	
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
func _set_is_Equipped():
	is_Equipped = get_parent().get_parent().get_parent()._set_is_Equipped(self)
	print(is_Equipped)

func _visual_is_Equipped():
	if is_Equipped && is_Inventory:
		equip_labeL.visible = true
	else:
		equip_labeL.visible = false
