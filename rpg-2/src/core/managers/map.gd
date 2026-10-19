
class_name MapManager
extends Node

const ROOM_SCENE := preload("res://src/levels/Room.tscn")
const ROOM_WIDTH := 16
const ROOM_HEIGHT := 8
const TILE_SIZE := 40

@onready var level_root: Node2D = %LevelRoot
@onready var foreground_root: Node2D = %ForegroundRoot
@onready var foreground_layer: TileMapLayer = %ForegroundLayer
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
	},
	Vector2i(0, 1): {
		"north": true,
		"east": true,
		"south": false,
		"west": false
	},
	Vector2i(1, 1): {
		"north": true,
		"east": false,
		"south": false,
		"west": true
	}
}
var visited_rooms: Array[Vector2i] = []

func _ready() -> void:
	generate_map()


func generate_map() -> void:
	# Clear the previous map and its shared foreground.
	for child in level_root.get_children():
		child.free()

	foreground_layer.clear()

	var tileset_assigned := false

	for map_position in map_data:
		var room_data: Dictionary = map_data[map_position]
		var room = ROOM_SCENE.instantiate()

		room.north_door = room_data["north"]
		room.east_door = room_data["east"]
		room.south_door = room_data["south"]
		room.west_door = room_data["west"]

		room.position = Vector2(
			map_position.x * ROOM_WIDTH * TILE_SIZE,
			map_position.y * ROOM_HEIGHT * TILE_SIZE
		)

		level_root.add_child(room)

		var room_tile_layer: TileMapLayer = room.get_node("TileMapLayer")

		# The shared layer uses the same TileSet resource as the room.
		if not tileset_assigned:
			foreground_layer.tile_set = room_tile_layer.tile_set
			tileset_assigned = true

		# Convert the room's map position to tile coordinates.
		var tile_offset := Vector2i(
			map_position.x * ROOM_WIDTH,
			map_position.y * ROOM_HEIGHT
		)

		configure_foreground(room)
		room.set_foreground_layer(
			foreground_layer,
			tile_offset
		)

		configure_room_transitions(room, map_position)
		room.player_exited.connect(
			_on_room_exit.bind(map_position)
		)

		print(
			"Room generated with tile map layer: ",
			room_tile_layer
		)

		room.generate_room()
		mark_room_visited(Vector2i(0, 0))

func configure_room_transitions(
	room: Node,
	map_position: Vector2i
) -> void:
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

	var player := get_tree().get_first_node_in_group("player") as Node2D

	if player:
		var destination_origin := Vector2(
			destination.x * ROOM_WIDTH * TILE_SIZE,
			destination.y * ROOM_HEIGHT * TILE_SIZE
		)

		var offset := Vector2(
			ROOM_WIDTH * TILE_SIZE / 2.0,
			ROOM_HEIGHT * TILE_SIZE / 2.0
		)

		match direction:
			Vector2i.RIGHT:
				player.global_position = destination_origin + Vector2(20, 180)
			Vector2i.LEFT:
				player.global_position = destination_origin + Vector2(620, 180)
			Vector2i.DOWN:
				player.global_position = destination_origin + Vector2(320, 20)
			Vector2i.UP:
				player.global_position = destination_origin + Vector2(320, 300)

	move_camera_to_room(destination)
	mark_room_visited(destination)

func move_camera_to_room(map_position: Vector2i) -> void:
	var target := Vector2(
		map_position.x * ROOM_WIDTH * TILE_SIZE
			+ (ROOM_WIDTH * TILE_SIZE) / 2,
		map_position.y * ROOM_HEIGHT * TILE_SIZE
			+ (ROOM_HEIGHT * TILE_SIZE) / 2
	)

	print_debug("camera target", target)

	var tween := create_tween()
	tween.tween_property(camera, "position", target, 0.3)

func configure_foreground(room: Node2D) -> void:
	var room_layer: TileMapLayer = room.get_node("TileMapLayer")

	if room_layer.tile_set:
		foreground_layer.tile_set = room_layer.tile_set

func mark_room_visited(room_position: Vector2i) -> void:
	if not visited_rooms.has(room_position):
		visited_rooms.append(room_position)
