extends Control

# Variable para almacenar el texto del diálogo
var dialogues = []
# Variable para llevar la cuenta de la posición actual en el diálogo
var current_dialogue_index = 0

# Referencias a los nodos Label y Button
@onready var dialogue_label = $Label
@onready var next_button = $Button

# Función para inicializar el diálogo
func _ready():
	dialogues = [
		"Hola, ¿cómo estás?",
		"Este es un sistema de diálogos en Godot.",
		"Puedes avanzar haciendo clic en el botón.",
		"¡Espero que esto te haya sido útil!"
	]
	update_dialogue()

# Función para actualizar el texto del diálogo
func update_dialogue():
	if current_dialogue_index < dialogues.size():
		dialogue_label.text = dialogues[current_dialogue_index]
	else:
		hide_dialogue()

# Función para avanzar al siguiente diálogo
func _on_Button_pressed():
	current_dialogue_index += 1
	update_dialogue()

# Función para ocultar el diálogo cuando se termine
func hide_dialogue():
	self.hide()
	# Aquí puedes añadir lógica adicional para lo que debería suceder después del diálogo

