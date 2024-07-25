extends Control

@onready var fire_grid = $Fuego
@onready var nature_grid = $Naturaleza
@onready var water_grid = $Agua
@onready var dark_grid = $Dark
var show_element: GridContainer
var show_num : int
var num_pressed  = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	_show_square_cursor(fire_grid,0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Singleton.is_stopped:
		_cursor_movement()
		if _get_element_square_texture_path(show_element,show_num) != "":
			_create_num_input()
			if num_pressed != "":
				num_pressed = _equip_spell(num_pressed)
	
func _get_element_square (element: GridContainer, num:int):
	return element.get_child(num).get_child(0)
func _get_element_square_texture_path (element: GridContainer, num:int):
	return element.get_child(num).texture_path
func _show_square_cursor(element: GridContainer, num:int):
	var icon = _get_element_square(element,num)
	show_element = element
	show_num = num
	icon._show_cursor()
	
func _hide_square_cursor(element: GridContainer, num:int):
	var icon = _get_element_square(element,num)
	icon._hide_cursor()

func _join_elements_right(element:GridContainer):
	match element:
		fire_grid:
			return nature_grid
		nature_grid:
			return water_grid
		water_grid:
			return dark_grid
		dark_grid:
			return fire_grid
func _join_elements_left(element:GridContainer):
	match element:
		fire_grid:
			return dark_grid
		nature_grid:
			return fire_grid
		water_grid:
			return nature_grid
		dark_grid:
			return water_grid
func _cursor_movement():
	if Input.is_action_just_pressed("ui_right"):
		_hide_square_cursor(show_element,show_num)
		if show_num % 2 == 0:
			_show_square_cursor(show_element,show_num + 1)
		else:
			show_element =_join_elements_right(show_element)
			_show_square_cursor(show_element,show_num - 1)
	if Input.is_action_just_pressed("ui_left"):
		_hide_square_cursor(show_element,show_num)
		if show_num % 2 == 1:
			_show_square_cursor(show_element,show_num - 1)
		else:
			show_element = _join_elements_left(show_element)
			_show_square_cursor(show_element,show_num + 1)
	if Input.is_action_just_pressed("ui_down"):
		_hide_square_cursor(show_element,show_num)
		if show_num < 4:
			_show_square_cursor(show_element,show_num + 2)
		else:
			_show_square_cursor(show_element,show_num - 4)
	if Input.is_action_just_pressed("ui_up"):
		_hide_square_cursor(show_element,show_num)
		if show_num > 1:
			_show_square_cursor(show_element,show_num - 2)
		else:
			_show_square_cursor(show_element,show_num + 4)

func _create_num_input():
	if Input.is_action_just_pressed("0"):
		num_pressed = "0"
	if Input.is_action_just_pressed("1"):
		num_pressed ="1"
	if Input.is_action_just_pressed("2"):
		num_pressed = "2"
	if Input.is_action_just_pressed("3"):
		num_pressed = "3"
	if Input.is_action_just_pressed("4"):
		num_pressed = "4"
	if Input.is_action_just_pressed("5"):
		num_pressed = "5"
	if Input.is_action_just_pressed("6"):
		num_pressed = "6"
	if Input.is_action_just_pressed("7"):
		num_pressed = "7"
	if Input.is_action_just_pressed("8"):
		num_pressed = "8"
	if Input.is_action_just_pressed("9"):
		num_pressed = "9"

func _equip_spell(input:String):
	if self.visible:
		var square = get_parent()._get_spell_square(int(input))
		get_parent()._correct_equipment(_get_element_square_texture_path(show_element,show_num))
		square._assign_texture(_get_element_square_texture_path(show_element,show_num))
	return ""
