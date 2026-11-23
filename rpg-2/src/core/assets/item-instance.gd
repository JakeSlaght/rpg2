extends Resource
class_name ItemInstance

@export_group("Identification")
@export var instance_id: StringName

@export_group("Item")
@export var item_data: ItemData
@export_range(1, 999) var quantity: int = 1

@export_group("State")
@export var item_state: Globals.ItemState
