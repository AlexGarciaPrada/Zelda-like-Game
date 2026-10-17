extends Node

const DEFINITIONS_PATH := "res://Spells/Definitions"
var definitions: Dictionary = {}


func _ready() -> void:
	_load_definitions(DEFINITIONS_PATH)


func cast(element: StringName, spell_id: StringName, level: int, caster: Node) -> bool:
	var definition := _get_definition(element, spell_id)
	if definition == null:
		return false
	return definition.cast(caster, level)


func has_spell(element: StringName, spell_id: StringName, level: int) -> bool:
	var definition := _get_definition(element, spell_id)
	return definition != null and definition.supports_level(level)


func _get_definition(element: StringName, spell_id: StringName) -> SpellDefinition:
	return definitions.get(_spell_key(element, spell_id)) as SpellDefinition


func _spell_key(element: StringName, spell_id: StringName) -> String:
	return "%s/%s" % [element, spell_id]


func _load_definitions(directory_path: String) -> void:
	var directory := DirAccess.open(directory_path)
	if directory == null:
		push_error("No se puede abrir el directorio de definiciones de hechizos: %s" % directory_path)
		return

	for file_name in directory.get_files():
		if file_name.get_extension().to_lower() not in ["tres", "res"]:
			continue
		var resource := ResourceLoader.load(directory_path.path_join(file_name))
		if not resource is SpellDefinition:
			continue
		var definition := resource as SpellDefinition
		var key := _spell_key(definition.element, definition.spell_id)
		if definitions.has(key):
			push_error("Hay más de una definición para el hechizo %s." % key)
			continue
		definitions[key] = definition

	for subdirectory in directory.get_directories():
		_load_definitions(directory_path.path_join(subdirectory))
