extends SpellEffect

const SCENE: PackedScene = preload("res://Spells/Lure/Lure.tscn")


func cast(caster: Node, level: int) -> void:
	var lure := SCENE.instantiate() as Node2D
	if lure == null:
		return
	lure.set("can_explode", level >= 2)
	caster.get_parent().add_child(lure)
	lure.global_position = caster.global_position
