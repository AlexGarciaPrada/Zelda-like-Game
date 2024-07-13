extends Control

var scene = Node
@export var scene_path : String

func _ready():
	scene = load(scene_path).instantiate()

func _on_area_2d_area_entered(area):

	if area.get_parent().get_parent().is_in_group("Player"):
		get_tree().root.add_child(scene)
		get_tree().current_scene.free()
