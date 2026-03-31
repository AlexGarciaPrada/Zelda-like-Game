class_name Mushroom
extends Enemy

@export var cloud_range = 100
@onready var venom_cloud_scene = preload("res://Enemies/Mushroom/VenomCloud.tscn")
@export var cooldown = 5
var time = cooldown


func _physics_process(delta):
	_movement()
	_check_create_venom_cloud()

func _create_venom_cloud():
	var venom_cloud = venom_cloud_scene.instantiate()
	venom_cloud.global_position = self.global_position
	get_parent().add_child(venom_cloud)
	
func _check_create_venom_cloud():
	if time >= cooldown && position.distance_to(player.position) < cloud_range:
		_create_venom_cloud()
func is_player_in_area():
	for area in enemyarea.get_overlapping_areas():
		if area.get_parent().is_in_group("Player"):
			return true
	return false
