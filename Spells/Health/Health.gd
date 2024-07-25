extends Node2D
@onready var particles = $GPUParticles2D
var finished = false
# Called when the node enters the scene tree for the first time.
func _ready():
	particles.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().knockback_mode:
		queue_free()


func _on_gpu_particles_2d_finished():
	get_parent().life += 1
