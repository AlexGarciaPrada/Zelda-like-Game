extends Control

@onready var canvas_layer = $CanvasLayer
@onready var overlay = $CanvasLayer/ColorRect

var base_color: Color = Color(0, 0, 0)

func _ready():
	base_color = overlay.color
	_day_mode()

func _cave_mode():
	canvas_layer.visible = true
	overlay.color = Color(base_color.r, base_color.g, base_color.b, 1.0)

func _exit_cave_mode():
	canvas_layer.visible = false
	overlay.color = Color(base_color.r, base_color.g, base_color.b, 0.0)
	
func _day_mode():
	canvas_layer.visible = false 
	overlay.color = Color(base_color.r, base_color.g, base_color.b, 0.0)

func _night_mode():
	canvas_layer.visible = true
	canvas_layer.color = Color(base_color.r, base_color.g, base_color.b, 0.3)
	overlay.color = Color(base_color.r, base_color.g, base_color.b, 0.3)
	
