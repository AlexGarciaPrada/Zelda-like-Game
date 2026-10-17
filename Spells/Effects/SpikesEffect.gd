extends ProjectileSpellEffect

const SCENE: PackedScene = preload("res://Spells/Spines/Spines.tscn")
const VERTICAL_DIRECTIONS: Array[Vector2] = [Vector2.UP, Vector2.DOWN]
const CARDINAL_DIRECTIONS: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]


func cast(caster: Node, level: int) -> void:
	var directions := CARDINAL_DIRECTIONS if level >= 3 else VERTICAL_DIRECTIONS
	var volleys := 2 if level >= 2 else 1
	for volley in range(volleys):
		if volley > 0:
			await caster.get_tree().create_timer(0.1).timeout
		for direction in directions:
			var spine := spawn_from_facing(caster, SCENE, direction)
			if spine == null:
				continue
			spine.rotation = Vector2.RIGHT.angle_to(direction)
			if direction == Vector2.UP or direction == Vector2.LEFT:
				spine.scale.y = -spine.scale.y
