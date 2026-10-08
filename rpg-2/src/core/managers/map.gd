class_name MapManager
extends Node

const ROOM_SCENE := preload("res://src/levels/Room.tscn")
const ROOM_WIDTH := 16
const ROOM_HEIGHT := 8
const TILE_SIZE := 40

@onready var level_root: Node2D = %LevelRoot

var map_data := {
	Vector2i(0, 0): {
		"north": false,
		"east": true,
		"south": true,
		"west": false
		}
	#},
	#Vector2i(1, 0): {
		#"north": false,
		#"east": false,
		#"south": true,
		#"west": true
	#}
}


func _ready() -> void:
	generate_map()

func generate_map() -> void:
	for map_position in map_data:
		var room_data: Dictionary = map_data[map_position]

		var room = ROOM_SCENE.instantiate()
		room.north_door = room_data["north"]
		room.east_door = room_data["east"]
		room.south_door = room_data["south"]
		room.west_door = room_data["west"]
		print_debug(room.north_door)
		print_debug(room.south_door)
		print_debug(room.east_door)
		print_debug(room.west_door)

		room.position = Vector2(
			map_position.x * ROOM_WIDTH * TILE_SIZE,
			map_position.y * ROOM_HEIGHT * TILE_SIZE
		)

		level_root.add_child(room)
		print('Room generated with tile map layer: ', room.get_node_or_null("TileMapLayer"))
		room.generate_room()
