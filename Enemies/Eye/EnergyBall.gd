extends Projectile2D

func _ready() -> void:
	projectile_speed = 200.0
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		queue_free()
