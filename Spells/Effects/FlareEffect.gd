extends ProjectileSpellEffect

const SCENE: PackedScene = preload("res://Spells/Flare/Flare.tscn")


func cast(caster: Node, _level: int) -> void:
	var direction := facing_direction(caster)
	var origin: Vector2 = caster.call("get_weapon_position", direction) + direction * 30.0
	caster.call("spawn_spell_effect", SCENE, direction, origin)
