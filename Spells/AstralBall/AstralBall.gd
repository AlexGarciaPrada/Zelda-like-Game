extends Projectile2D

@onready var animation = $AnimatedSprite2D
func _ready():
	projectile_speed = 300.0
	animation.play("movement")
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
