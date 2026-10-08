extends Node2D

const ROOM_WIDTH := 16
const ROOM_HEIGHT := 8

@export var north_door := false
@export var east_door := false
@export var south_door := false
@export var west_door := false

func _ready() -> void:
	Bus.room_configuration_changed.connect(regenerate)

func generate_room() -> void:
	var tile_map_layer: TileMapLayer = %TileMapLayer
	tile_map_layer.clear()
	
	print("GENERATING ROOM")
	print("tile_map_layer = ", tile_map_layer)
	
	for y in range(ROOM_HEIGHT):
		for x in range(ROOM_WIDTH):
			var tile_position := Vector2i(x, y)

			if _is_wall(tile_position):
				if _is_door(tile_position):
					_set_floor(tile_position, tile_map_layer)
				else:
					_set_wall(tile_position, tile_map_layer)
			else:
				_set_floor(tile_position, tile_map_layer)


func _is_wall(position: Vector2i) -> bool:
	return (
		position.x == 0
		or position.x == ROOM_WIDTH - 1
		or position.y == 0
		or position.y == ROOM_HEIGHT - 1
	)


func _is_door(position: Vector2i) -> bool:
	if north_door and position == Vector2i(7, 0):
		return true

	if south_door and position == Vector2i(7, ROOM_HEIGHT - 1):
		return true

	if west_door and position == Vector2i(0, 4):
		return true

	if east_door and position == Vector2i(ROOM_WIDTH - 1, 4):
		return true

	return false


func _set_floor(position: Vector2i, tile_map_layer: TileMapLayer) -> void:
	tile_map_layer.set_cell(position, 0, Vector2i(1, 0))


func _set_wall(position: Vector2i, tile_map_layer: TileMapLayer) -> void:
	tile_map_layer.set_cell(position, 0, Vector2i(0, 0))

func regenerate(north, east, south, west) -> void:
	print("MAP MANAGER RECEIVED: ", north, east, south, west)
	self.north_door = north
	self.south_door = south
	self.east_door = east
	self.west_door = west
	generate_room()
