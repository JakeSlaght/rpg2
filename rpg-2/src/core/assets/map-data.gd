extends Resource
class_name MapData

@export var map_name: String
@export var rooms: Dictionary[Vector2i, RoomData] = {}
@export var terrain_set: Resource
@export var enemy_set: Resource
