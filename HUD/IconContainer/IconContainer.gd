extends Control
@onready var icon_cont = $Panel/TextureRect
@onready var label = $Panel/TextureRect/Label
@export var label_text = "1"
@export var icon_route = "res://HUD/Icon/Icon.tscn"
var icon_scene = preload("res://HUD/Icon/Icon.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = label_text
	modulate = Color(Color.AQUA,0.7)
	var icon_instance = icon_scene.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Singleton.is_dragging:
		visible=true
	else:
		visible = false
		
