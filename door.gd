extends Control

var scene = Node
@export var scene_path : String
var areas = []

func _ready():
	scene = load(scene_path).instantiate()

func _process(delta):
	if !areas.is_empty():
		for area in areas:
			if area.get_parent().is_in_group("Player"):
				Singleton.hud = area.get_parent().hud.duplicate()
				get_tree().root.add_child(scene)
				get_tree().current_scene.free()
				

	

func _on_area_2d_area_entered(area):
	areas.append(area)



func _on_area_2d_area_exited(area):
	areas.erase(area)

