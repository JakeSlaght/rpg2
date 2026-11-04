
class_name MapManager
extends Node

const ROOM_SCENE := preload("res://src/levels/Room.tscn")
const NPC_SCENE := preload("res://src/gameplay/Entities/NPC.tscn")
const ROOM_WIDTH := 16
const ROOM_HEIGHT := 8
const TILE_SIZE := 40

@onready var entity_root: Node2D = %EntityRoot
@onready var level_root: Node2D = %LevelRoot
@onready var foreground_root: Node2D = %ForegroundRoot
@onready var foreground_layer: TileMapLayer = %ForegroundLayer
@onready var camera: Camera2D = %Camera2D
@onready var party_manager: PartyManager = %PartyManager

@export var map_data: MapData

var visited_rooms: Array[Vector2i] = []

func _ready() -> void:
	if map_data == null:
		push_error("MapManager: No Map Data Loaded")
		return

	generate_player.call_deferred()
	generate_map()
	

func generate_player() -> void:
	var character := CharacterData.new()
	character.sprite_frames = load("res://src/gameplay/Player/temp.tres")
	party_manager.add_to_available_character_list(character)
	party_manager.add_to_active_roster(character)
	party_manager.set_active_character(0)

func generate_map() -> void:
	# Clear the previous map and its shared foreground.
	for child in level_root.get_children():
		child.free()

	foreground_layer.clear()

	#var tileset_assigned := false

	for map_position in map_data.rooms:
		var room_data: RoomData = map_data.rooms[map_position]
		var room = ROOM_SCENE.instantiate()

		room.north_door = room_data.north
		room.east_door = room_data.east
		room.south_door = room_data.south
		room.west_door = room_data.west

		room.position = Vector2(
			map_position.x * ROOM_WIDTH * TILE_SIZE,
			map_position.y * ROOM_HEIGHT * TILE_SIZE
		)

		level_root.add_child(room)

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

		room.generate_room()
		room.setup_npcs(room_data.npcs, entity_root)
		

	# Mark the starting room as discovered once the map is generated.
	mark_room_visited(Vector2i(0, 0))

func configure_room_transitions(
	room: Node,
	map_position: Vector2i
) -> void:
	room.set_transition_enabled(
		Vector2i.UP,
		map_data.rooms.has(map_position + Vector2i.UP)
	)
	room.set_transition_enabled(
		Vector2i.RIGHT,
		map_data.rooms.has(map_position + Vector2i.RIGHT)
	)
	room.set_transition_enabled(
		Vector2i.DOWN,
		map_data.rooms.has(map_position + Vector2i.DOWN)
	)
	room.set_transition_enabled(
		Vector2i.LEFT,
		map_data.rooms.has(map_position + Vector2i.LEFT)
	)


func _on_room_exit(direction: Vector2i, current_room: Vector2i) -> void:
	var destination := current_room + direction

	if not map_data.rooms.has(destination):
		return

	var player := get_tree().get_first_node_in_group("player") as Node2D

	if player:
		var destination_origin := Vector2(
			destination.x * ROOM_WIDTH * TILE_SIZE,
			destination.y * ROOM_HEIGHT * TILE_SIZE
		)

		#var offset := Vector2(
			#ROOM_WIDTH * TILE_SIZE / 2.0,
			#ROOM_HEIGHT * TILE_SIZE / 2.0
		#)

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
		map_position.x * ROOM_WIDTH * TILE_SIZE + (ROOM_WIDTH * TILE_SIZE) / 2,
		map_position.y * ROOM_HEIGHT * TILE_SIZE + (ROOM_HEIGHT * TILE_SIZE) / 2
	)

	var tween := create_tween()
	tween.tween_property(camera, "position", target, 0.3)


func configure_foreground(room: Node2D) -> void:
	var room_layer: TileMapLayer = room.get_node("TileMapLayer")

	if room_layer.tile_set:
		foreground_layer.tile_set = room_layer.tile_set

func mark_room_visited(room_position: Vector2i) -> void:
	if not map_data.rooms.has(room_position):
		return

	map_data.rooms[room_position].is_discovered = true
