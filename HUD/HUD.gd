extends Control

@onready var life_label = $VBoxContainer/Label
@export var spell = ""
@onready var spellSet = $GridContainer
@onready var notEquippedLabel = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_label.text = str(get_parent().get_parent().life)

func _get_spell_square(num):
	var icon = $GridContainer.get_child(num - 1)
	return icon
	
func _show_not_equipped_spell():
	notEquippedLabel.visible=true
	await get_tree().create_timer(0.75).timeout
	notEquippedLabel.visible=false

func _set_is_Equipped(icon):
	if icon.texture != null:
		for i in range (1,11):
			var square = _get_spell_square(i)
			if square.texture == icon.texture:
				return true
		return false
	else:
		return false
