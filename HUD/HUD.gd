extends Control

@onready var life_label =$CanvasLayer/VBoxContainer/Label
@export var spell = ""
@onready var spellSet =$CanvasLayer/GridContainer
@onready var notEquippedLabel = $CanvasLayer/Label
@onready var inventory = $CanvasLayer/Inventory
@onready var map = $CanvasLayer/Mapa
@onready var spells =$CanvasLayer/INVHechizos
# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_spellset_mode_gameplay()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_label.text = str(get_parent().get_parent()._get_life())

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
func _change_to_map():
	map.visible = true
	spells.visible = false
	inventory.visible = false
func _change_to_inventory():
	map.visible = false
	inventory.visible = true
	spells.visible = false

func _change_to_spells():
	map.visible = false
	inventory.visible = false
	spells.visible = true

func _change_page():
	if Input.is_action_just_pressed("A"):
		if inventory.visible:
			_change_to_spells()
		elif map.visible:
			_change_to_inventory()
		elif spells.visible:
			_change_to_map()
	if Input.is_action_just_pressed("D"):
		if inventory.visible:
			_change_to_map()
		elif map.visible:
			_change_to_spells()
		elif spells.visible:
			_change_to_inventory()
func _get_canva_modulate():
	return $Shader.get_child(0)

func _activate_fog():
	$Fog.visible = true
	
func _desactivate_fog():
	$Fog.visible = false

func _cave_mode():
	pass
