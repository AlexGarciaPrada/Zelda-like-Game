extends Control

@onready var life_label = $VBoxContainer/Label
@export var spell = ""
@onready var spellSet = $GridContainer
@onready var notEquippedLabel = $Label
@onready var inventory = $Inventory
# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_label.text = str(get_parent().get_parent().life)

func _get_spell_square(num):
	var icon = spellSet.get_child(num - 1).get_child(0)
	return icon
	
func _show_not_equipped_spell():
	if notEquippedLabel!= null:
		notEquippedLabel.visible=true
	await get_tree().create_timer(0.75).timeout
	notEquippedLabel.visible=false
	
func _show_inventory():
	inventory.visible = true
func _hide_inventory():
	inventory.visible = false
