class_name Mushroom
extends Enemy

@export var cloud_range = 100
@onready var venom_cloud_scene = preload("res://Enemies/Mushroom/VenomCloud.tscn")
@export var cooldown = 5
var time = cooldown


func _physics_process(delta: float) -> void:
	if Singleton.is_stopped or is_dying:
		return
	super._physics_process(delta)
	time += delta
	_check_create_venom_cloud()
	
func _create_venom_cloud():
	var venom_cloud = venom_cloud_scene.instantiate()
	venom_cloud.global_position = self.global_position
	get_parent().add_child(venom_cloud)
	time = 0
	
func _check_create_venom_cloud():
	if (
		is_instance_valid(player)
		and not player.is_invisible
		and not player.is_invisible_max
		and time >= cooldown
		and global_position.distance_to(player.global_position) < cloud_range
	):
		_create_venom_cloud()
		
func is_player_in_area():
	for area in enemy_area.get_overlapping_areas():
		if is_instance_valid(area) and is_instance_valid(area.get_parent()) and area.get_parent().is_in_group("Player"):
			return true
	return false
