class_name SpellDefinition
extends Resource

@export var element: StringName
@export var spell_id: StringName
@export var supported_levels: PackedInt32Array = PackedInt32Array([1])
@export var effect_script: Script


func supports_level(level: int) -> bool:
	return supported_levels.has(level)


func cast(caster: Node, level: int) -> bool:
	if not supports_level(level) or effect_script == null:
		return false
	var effect := effect_script.new() as SpellEffect
	if effect == null:
		push_error("El efecto del hechizo %s no hereda de SpellEffect." % spell_id)
		return false
	effect.cast(caster, level)
	return true
