extends SpellEffect

const SCENE: PackedScene = preload("res://Spells/Health/Health.tscn")


func cast(caster: Node, _level: int) -> void:
	if caster.get("life") >= caster.get("max_life"):
		return
	var health_scene := SCENE.instantiate()
	caster.add_child(health_scene)
