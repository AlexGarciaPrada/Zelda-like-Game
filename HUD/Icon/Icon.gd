extends Control

@onready var icon = $TextureRect
var dragging = false
var drag_offset = Vector2()
var mouse_over = false

func _ready():
	# Asegura que el nodo reciba los eventos de entrada
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mouse_over:
			dragging = true
			drag_offset = get_local_mouse_position() - icon.position
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		icon.position = event.position - drag_offset

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
