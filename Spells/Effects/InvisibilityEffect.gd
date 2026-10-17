extends SpellEffect


func cast(caster: Node, level: int) -> void:
	caster.call("set_invisibility", level)
