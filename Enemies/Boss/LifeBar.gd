extends Control

@onready var progressbar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	progressbar.max_value = get_parent().life
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progressbar.value = get_parent().life
