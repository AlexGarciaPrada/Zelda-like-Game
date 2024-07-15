extends Node2D

var draggable = false
var is_inside_droppable = false
var body_ref
var not_done = false
var offset : Vector2
var initialPos: Vector2
var previous_texture : CompressedTexture2D

@onready var sprite = $Sprite2D
@export var this_texture :CompressedTexture2D
func _ready():
	z_index=2
	if this_texture != null:
		sprite.texture = this_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		visible = true
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position()-global_position
			Singleton.is_dragging = true
		if Input.is_action_pressed("click"):
			offset = get_global_mouse_position()-global_position
			global_position = get_global_mouse_position()
			self.scale = Vector2 (1.5,1.5)
		elif Input.is_action_just_released("click"):
			Singleton.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_droppable:
				tween.tween_property(self,"position",body_ref.position,0.2).set_ease(Tween.EASE_OUT)
				if !body_ref.get_parent().is_inventory:
					body_ref.get_child(2).texture = self.get_child(0).texture
					if !self.get_parent().get_parent().is_inventory && self.get_parent()!= body_ref:
						self.get_parent().this_texture.texture = null
				queue_free()
			else:
				queue_free()

func _on_area_2d_mouse_entered():
	if !Singleton.is_dragging:
		draggable = true


func _on_area_2d_mouse_exited():
	if !Singleton.is_dragging:
		draggable = false



func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("droppable"):
		is_inside_droppable = false
		


func _on_area_2d_area_entered(area):
		if area.get_parent().is_in_group("droppable"):
			is_inside_droppable = true
			body_ref = area.get_parent()
