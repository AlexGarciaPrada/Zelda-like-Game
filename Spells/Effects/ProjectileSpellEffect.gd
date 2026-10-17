class_name ProjectileSpellEffect
extends SpellEffect


func facing_direction(caster: Node) -> Vector2:
	return caster.call("get_facing_direction")


func spawn_from_facing(caster: Node, scene: PackedScene, direction: Vector2) -> Projectile2D:
	var origin: Vector2 = caster.call("get_weapon_position", direction)
	return caster.call("spawn_spell_projectile", scene, direction, origin) as Projectile2D
