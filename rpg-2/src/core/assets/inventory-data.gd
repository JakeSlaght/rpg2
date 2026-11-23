extends Resource
class_name InventoryData

@export_group("General")
@export var inventory_id: StringName
@export var inventory_owner: StringName

@export_group("Capacity")
@export_range(1, 999) var maximum_slots: int = 20

@export_group("Contents")
@export var inventory_slots: Array[ItemInstance] = []
