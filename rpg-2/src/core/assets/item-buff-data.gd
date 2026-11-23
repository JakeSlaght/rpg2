extends Resource
class_name ItemBuffData

@export_group("Damage")
@export var damage_modifiers: Array[DamageModifierData] = []

@export_group("Stats")
@export var stat_modifiers: Dictionary = {}

@export_group("Skills")
@export var skill_modifiers: Dictionary = {}
