extends TileMap

@onready var player = $"../Wizard"

var last_cell = Vector2i()

var beach_tilemap_n = 14
var sand_coordenates = [Vector2i(0,0)]
func _ready():
	last_cell = local_to_map(player.global_position)

func _process(delta):
	var current_cell = local_to_map(player.global_position)
	if current_cell != last_cell:
		_check_footprint(last_cell)
		last_cell = current_cell


func _check_footprint(cell):
	var source_id = get_cell_source_id(0, cell)
	var atlas_coords = get_cell_atlas_coords(0, cell)
	
	print(source_id)
	print(atlas_coords)

	if source_id == beach_tilemap_n and atlas_coords in sand_coordenates:
		_footprint(cell)

func _footprint(cell):
	var flip_h = false
	var flip_v = false
	var transpose = false

	match player.clue:
		"down":
			flip_h = false
			flip_v = false
			transpose = false

		"up":
			flip_h = true
			flip_v = true
			transpose = false

		"right":
			flip_h = false
			flip_v = false
			transpose = true

		"left":
			flip_h = true
			flip_v = true
			transpose = true

	set_cell(1, cell, 14, Vector2i(1, 2))
