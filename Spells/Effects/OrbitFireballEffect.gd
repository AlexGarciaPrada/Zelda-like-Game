extends SpellEffect

const SCENE: PackedScene = preload("res://Spells/RotatingFireball/RotatingFireball.tscn")
const ORBIT_ANGLES: Dictionary = {
	1: [0.0],
	2: [0.0, PI],
	3: [PI / 2.0, 7.0 * PI / 6.0, 11.0 * PI / 6.0],
}


func cast(caster: Node, level: int) -> void:
	for angle in ORBIT_ANGLES.get(level, []):
		var fireball := SCENE.instantiate()
		fireball.set("center", caster)
		fireball.set("angle", angle)
		caster.get_parent().add_child(fireball)
