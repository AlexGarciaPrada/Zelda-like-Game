extends Control

@onready var life_label = $VBoxContainer/Label
@export var spell = ""
@onready var spellSet = $GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_label.text = str(get_parent().get_parent().life)

func _get_spell_square(num):
	return spellSet.get_child(num )
