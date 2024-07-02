extends Control

# Variable para almacenar el texto del diálogo
var dialogues = []
# Variable para llevar la cuenta de la posición actual en el diálogo
var current_dialogue_index = 0

# Referencias a los nodos Label y Button
@onready var dialogue_label =$CanvasLayer/TextureRect/Label
@onready var dialogue_box=$CanvasLayer
# Función para inicializar el diálogo
func _ready():
	Singleton.is_stopped = true
	update_dialogue()
func _physics_process(delta):
	_dialogue_pass()
# Función para actualizar el texto del diálogo
func update_dialogue():
	if current_dialogue_index < dialogues.size():
		dialogue_label.text = dialogues[current_dialogue_index]
	else:
		Singleton.is_stopped = false
		hide_dialogue()


# Función para ocultar el diálogo cuando se termine
func hide_dialogue():
	if current_dialogue_index !=0:
		queue_free()
	dialogue_box.visible=false
	# Aquí puedes añadir lógica adicional para lo que debería suceder después del diálogo


func _dialogue_pass():
	if Input.is_action_just_pressed("Lure"):
		current_dialogue_index += 1
		update_dialogue()
