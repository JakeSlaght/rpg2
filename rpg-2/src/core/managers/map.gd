class_name MapManager
extends Node

const ROOM_SCENE := preload("res://src/levels/Room.tscn")
const ROOM_WIDTH := 16
const ROOM_HEIGHT := 8
const TILE_SIZE := 40

@onready var level_root: Node2D = %LevelRoot
@onready var camera: Camera2D = %Camera2D

var map_data := {
	Vector2i(0, 0): {
		"north": false,
		"east": true,
		"south": true,
		"west": false
		},
	Vector2i(1, 0): {
		"north": false,
		"east": false,
		"south": true,
		"west": true
	}
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
		configure_room_transitions(room, map_position)
		room.player_exited.connect(_on_room_exit.bind(map_position))
		print('Room generated with tile map layer: ', room.get_node_or_null("TileMapLayer"))
		room.generate_room()


func configure_room_transitions(room: Node, map_position: Vector2i) -> void:
		room.set_transition_enabled(
			Vector2i.UP,
			map_data.has(map_position + Vector2i.UP)
			)
		room.set_transition_enabled(
			Vector2i.RIGHT,
			map_data.has(map_position + Vector2i.RIGHT)
			)
		room.set_transition_enabled(
			Vector2i.DOWN,
			map_data.has(map_position + Vector2i.DOWN)
			)
		room.set_transition_enabled(
			Vector2i.LEFT,
			map_data.has(map_position + Vector2i.LEFT)
			)


func _on_room_exit(direction: Vector2i, current_room: Vector2i) -> void:
		print_debug("ROOM EXIT TRIGGER", current_room, direction)
		
		var destination := current_room + direction
		
		if not map_data.has(destination):
			return
		
		move_camera_to_room(destination)

func move_camera_to_room(map_position: Vector2i) -> void:
	var target := Vector2(
		map_position.x * ROOM_WIDTH * TILE_SIZE + (ROOM_WIDTH * TILE_SIZE) / 2,
		map_position.y * ROOM_HEIGHT * TILE_SIZE + (ROOM_HEIGHT * TILE_SIZE) / 2
		)
		
	print_debug("camera target", target)
	var tween := create_tween()
	tween.tween_property(camera, "position", target, 0.3)
