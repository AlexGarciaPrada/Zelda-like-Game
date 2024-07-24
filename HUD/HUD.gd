extends Control

@onready var life_label = $VBoxContainer/Label
@export var spell = ""
@onready var spellSet = $GridContainer
@onready var notEquippedLabel = $Label
@onready var inventory = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_spellset_mode_gameplay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_label.text = str(get_parent().get_parent().life)

func _get_spell_square(num):
	var icon = spellSet.get_child(num - 1)
	return icon
	
func _show_not_equipped_spell():
	if notEquippedLabel!= null:
		notEquippedLabel.visible=true
	await get_tree().create_timer(0.75).timeout
	notEquippedLabel.visible=false
	
func _show_inventory():
	inventory.visible = true
	_spellset_mode_inventory()
func _hide_inventory():
	inventory.visible = false
	_spellset_mode_gameplay()

func _correct_equipment(texture_path:String):
	for i in range(1,11):
		if spellSet.get_child(i - 1).texture_path == texture_path:
			spellSet.get_child(i-1)._remove_texture()

func _spellset_mode_gameplay():
	spellSet.position = Vector2(192,40)
	spellSet.scale = Vector2 (0.9,0.9)
	for square in spellSet.get_children():
		square._gameplay_mode()
func _spellset_mode_inventory():
	spellSet.position = Vector2(104,424)
	spellSet.scale = Vector2 (1,1)
	for square in spellSet.get_children():
		square._inventory_mode()
