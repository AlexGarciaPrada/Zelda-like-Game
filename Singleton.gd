extends Node

var is_stopped = false
var is_dragging = false
 #Para guardar entre escenas
var life_player:int
var hud :Control

func _ready():
	hud = null
	life_player = 5
