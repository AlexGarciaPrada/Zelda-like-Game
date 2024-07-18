extends CharacterBody2D

@export var SPEED = 200


func _process(delta):
	position += velocity * delta
	var collision = move_and_collide( velocity * delta)
	if collision:
		queue_free()
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		queue_free()
