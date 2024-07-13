extends Control

var element : String
var spell : String
var level : int
@export var number_label = ""
@export var is_inventory = true
@export var texture_path = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _get_element():
	return element

func _get_spell():
	return spell

func _get_level():
	return level
