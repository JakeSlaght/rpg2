extends Resource
class_name ItemData

@export_group("General")
@export var item_id: StringName
@export var item_name: String
@export_multiline var description: String
@export var classification: Globals.ItemClassification

@export_group("Economy")
@export var sellable: bool = true
@export var cost: int = 0
@export var weight: float = 0.0

@export_group("Usage")
@export var equippable: bool = false
@export var class_requirements: Array[Globals.ClassType] = []

@export_group("Stacking")
@export_range(1, 999) var max_stack: int = 1

@export_group("Effects")
@export var buffs: Array[ItemBuffData] = []
