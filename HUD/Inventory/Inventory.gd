extends Control

@onready var fire_grid = $Fuego
@onready var nature_grid = $Naturaleza
@onready var water_grid = $Agua
@onready var dark_grid = $Dark
var show_element: GridContainer
var show_num : int

# Called when the node enters the scene tree for the first time.
func _ready():
	_show_square_cursor(fire_grid,0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Singleton.is_stopped:
		_cursor_movement()
	
func _get_element_square (element: GridContainer, num:int):
	return element.get_child(num)

func _show_square_cursor(element: GridContainer, num:int):
	var icon = _get_element_square(element,num).get_child(0)
	show_element = element
	show_num = num
	icon._show_cursor()
	
func _hide_square_cursor(element: GridContainer, num:int):
	var icon = _get_element_square(element,num).get_child(0)
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
