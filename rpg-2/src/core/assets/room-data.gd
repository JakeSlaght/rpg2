extends Resource
class_name RoomData

@export var north: bool = false
@export var east: bool = false
@export var south: bool = false
@export var west: bool = false

@export_range(0, 100) var enemy_count: int = 0
@export var npcs: Array[ NPCData ] = []
@export var poi_type: Globals.RoomType = Globals.RoomType.None
@export var room_environment: Globals.RoomEnvironment = Globals.RoomEnvironment.Indoor

@export var is_discovered: bool = false
@export var is_cleared: bool = false
