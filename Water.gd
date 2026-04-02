extends Node2D

@export_group("Dimensiones")
@export var point_count: int = 150
@export var width: float = 800.0
@export var depth: float = 500.0 
@export var base_water_level: float = 0.0 

@export_group("Marea y Olas")
@export var tide_speed: float = 0.5 
@export var max_tide_height: float = 50.0 
@export var max_wave_amplitude: float = 10.0 
@export var wave_speed: float = 2.0 
@export var wave_frequency: float = 0.015 

var time: float = 0.0

func _process(delta):
	# Evita errores si el Polygon2D no existe
	if not has_node("Polygon2D"):
		return
		
	time += delta
	update_water()

func update_water():
	var line_points: PackedVector2Array = []
	var poly_points: PackedVector2Array = []
	var poly_uvs: PackedVector2Array = []

	# 1. Calculamos el ciclo de la marea (va de 0.0 a 1.0)
	var tide_cycle = (sin(time * tide_speed) + 1.0) / 2.0
	
	# 2. Calculamos la altura y la fuerza de las olas actual
	var current_tide = tide_cycle * max_tide_height
	var current_amplitude = tide_cycle * max_wave_amplitude

	# 3. Generamos los puntos de la superficie
	for i in range(point_count):
		var t = i / float(point_count - 1)
		var x = t * width
		
		var wave = sin(x * wave_frequency) * cos(time * wave_speed) * current_amplitude
		var y = base_water_level - current_tide + wave

		var pos = Vector2(x, y)
		
		if has_node("Line2D"):
			line_points.append(pos)
			
		poly_points.append(pos)
		poly_uvs.append(Vector2(t, 0.0)) # Indicamos al shader que esto es "arriba"

	# 4. Cerramos el polígono por la parte de abajo
	poly_points.append(Vector2(width, depth))
	poly_uvs.append(Vector2(1.0, 1.0)) # Abajo derecha
	
	poly_points.append(Vector2(0, depth))
	poly_uvs.append(Vector2(0.0, 1.0)) # Abajo izquierda

	# 5. Aplicamos la geometría a los nodos
	if has_node("Line2D"):
		$Line2D.points = line_points
		
	$Polygon2D.polygon = poly_points
	$Polygon2D.uv = poly_uvs

	# 6. Opcional: Ajustamos la espuma del shader según la marea
	var mat = $Polygon2D.material
	if mat is ShaderMaterial:
		# La espuma será 0 si la marea está baja, y 0.02 si está alta
		var foam_thickness = lerp(0.0, 0.02, tide_cycle) 
		mat.set_shader_parameter("grosor_espuma", foam_thickness)
