extends Control
var texture_name: String
var element : String
var spell : String
var level : int
@export var number_label = ""
@export var is_inventory = true
@export var texture_path = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if texture_path != "":
		_assign_texture(texture_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _get_element():
	return element

func _assign_texture(texture : String):
	texture_name = texture.get_file().get_basename()
	texture_path = texture
	_make_texture()
	
func _remove_texture():
	texture_path = ""
	element = ""
	spell = ""
	level = 0 #Valor por defecto de godot cuando haces :int
	get_child(0).this_texture.texture = null
	get_child(0).border.visible = true
	
func _get_spell():
	return spell

func _get_level():
	return level
	
func _make_texture():
	var parts = texture_name.split("_")
	element = parts[0]
	spell = parts[1]
	level = int(parts[2])	
	get_child(0).this_texture.texture = load(texture_path)
	get_child(0).border.visible = false
