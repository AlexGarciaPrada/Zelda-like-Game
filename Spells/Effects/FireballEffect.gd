extends ProjectileSpellEffect

const SCENE: PackedScene = preload("res://Spells/FireBall/FireBall.tscn")


func cast(caster: Node, _level: int) -> void:
	spawn_from_facing(caster, SCENE, facing_direction(caster))
