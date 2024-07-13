extends StaticBody2D

@export var number_label = ""
var icon_scene = preload("res://HUD/IconsV2/IconsV2.tscn")
@export var texture_path : String
var mouse_in = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = number_label
	if texture_path != null:
		$TextureRect.texture = load(texture_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_in:
		if $TextureRect.texture != null:
			var icon = icon_scene.instantiate()
			icon.this_texture = $TextureRect.texture
			self.add_child(icon)
			mouse_in = false

		


func _on_area_2d_mouse_entered():
	mouse_in = true
	

func _on_area_2d_mouse_exited():
	mouse_in = false
