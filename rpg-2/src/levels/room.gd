
extends Node2D

const ROOM_WIDTH := 16
const ROOM_HEIGHT := 8

# Placeholder atlas coordinates; update when the tiles are added.
const FLOOR_TILE := Vector2i(1, 1)
const WALL_TILE := Vector2i(1, 0)
const CORNER_TILE := Vector2i(2, 0)
const OPEN_DOOR_TILE := Vector2i(0, 0)
const CLOSE_DOOR_TILE := Vector2i(0, 1)
const DOORFRAME_TILE := Vector2i(2, 1)

# Rotation steps: clockwise from the north-facing base tile.
const ROTATE_NORTH := 0
const ROTATE_EAST := 1
const ROTATE_SOUTH := 2
const ROTATE_WEST := 3

@export var north_door := false
@export var east_door := false
@export var south_door := false
@export var west_door := false

@onready var east_area: Area2D = %EastArea
@onready var south_area: Area2D = %SouthArea
@onready var west_area: Area2D = %WestArea
@onready var north_area: Area2D = %NorthArea

signal player_exited(direction: Vector2i)

# Shared foreground layer, assigned by MapManager.
var foreground_layer: TileMapLayer
var foreground_tile_offset := Vector2i.ZERO
var _foreground_positions: Array[Vector2i] = []


func _ready() -> void:
	Bus.room_configuration_changed.connect(regenerate)

	north_area.body_entered.connect(
		_on_transition_entered.bind(Vector2i.UP)
	)
	east_area.body_entered.connect(
		_on_transition_entered.bind(Vector2i.RIGHT)
	)
	south_area.body_entered.connect(
		_on_transition_entered.bind(Vector2i.DOWN)
	)
	west_area.body_entered.connect(
		_on_transition_entered.bind(Vector2i.LEFT)
	)


func set_foreground_layer(
	layer: TileMapLayer,
	tile_offset: Vector2i
) -> void:
	foreground_layer = layer
	foreground_tile_offset = tile_offset


func generate_room() -> void:
	var tile_map_layer: TileMapLayer = %TileMapLayer
	tile_map_layer.clear()

	# Remove only this room's previously drawn foreground tiles.
	if is_instance_valid(foreground_layer):
		for pos in _foreground_positions:
			foreground_layer.erase_cell(pos)

	_foreground_positions.clear()

	print("GENERATING ROOM")
	print("tile_map_layer = ", tile_map_layer)

	for y in range(ROOM_HEIGHT):
		for x in range(ROOM_WIDTH):
			var tile_position := Vector2i(x, y)

			if _is_corner(tile_position):
				_set_corner(tile_position, tile_map_layer)
			elif _is_door(tile_position):
				# Keep the doorway open on the regular layer.
				_set_floor(tile_position, tile_map_layer)

				# Draw the door frame above the player.
				_set_door(tile_position)
			elif _is_wall(tile_position):
				_set_wall(tile_position, tile_map_layer)
			else:
				_set_floor(tile_position, tile_map_layer)


func _is_wall(wall_pos: Vector2i) -> bool:
	return (
		wall_pos.x == 0
		or wall_pos.x == ROOM_WIDTH - 1
		or wall_pos.y == 0
		or wall_pos.y == ROOM_HEIGHT - 1
	)


func _is_corner(corner_pos: Vector2i) -> bool:
	return (
		(corner_pos.x == 0 or corner_pos.x == ROOM_WIDTH - 1)
		and
		(corner_pos.y == 0 or corner_pos.y == ROOM_HEIGHT - 1)
	)


func _is_door(door_pos: Vector2i) -> bool:
	if north_door and door_pos == Vector2i(7, 0):
		return true

	if south_door and door_pos == Vector2i(7, ROOM_HEIGHT - 1):
		return true

	if west_door and door_pos == Vector2i(0, 4):
		return true

	if east_door and door_pos == Vector2i(ROOM_WIDTH - 1, 4):
		return true

	return false


func _set_floor(
	floor_pos: Vector2i,
	tile_map_layer: TileMapLayer
) -> void:
	tile_map_layer.set_cell(floor_pos, 0, FLOOR_TILE)


func _set_wall(
	wall_pos: Vector2i,
	tile_map_layer: TileMapLayer
) -> void:
	var rotation_steps := ROTATE_NORTH

	if wall_pos.x == ROOM_WIDTH - 1:
		rotation_steps = ROTATE_EAST
	elif wall_pos.y == ROOM_HEIGHT - 1:
		rotation_steps = ROTATE_SOUTH
	elif wall_pos.x == 0:
		rotation_steps = ROTATE_WEST

	_set_rotated_tile(
		wall_pos,
		WALL_TILE,
		rotation_steps,
		tile_map_layer
	)


func _set_corner(
	corner_pos: Vector2i,
	tile_map_layer: TileMapLayer
) -> void:
	var rotation_steps := ROTATE_NORTH

	if corner_pos.x == 0 and corner_pos.y == 0:
		rotation_steps = ROTATE_WEST
	elif (
		corner_pos.x == ROOM_WIDTH - 1
		and corner_pos.y == ROOM_HEIGHT - 1
	):
		rotation_steps = ROTATE_EAST
	elif corner_pos.x == 0 and corner_pos.y == ROOM_HEIGHT - 1:
		rotation_steps = ROTATE_SOUTH

	_set_rotated_tile(
		corner_pos,
		CORNER_TILE,
		rotation_steps,
		tile_map_layer
	)


func _set_door(door_pos: Vector2i) -> void:
	var tile_map_layer: TileMapLayer = %TileMapLayer
	if not is_instance_valid(foreground_layer):
		push_warning("ForegroundLayer has not been assigned.")
		return

	var rotation_steps := ROTATE_NORTH

	if door_pos == Vector2i(ROOM_WIDTH - 1, 4):
		rotation_steps = ROTATE_EAST
	elif door_pos == Vector2i(7, ROOM_HEIGHT - 1):
		rotation_steps = ROTATE_SOUTH
	elif door_pos == Vector2i(0, 4):
		rotation_steps = ROTATE_WEST

	# Convert room-local coordinates into shared world tile coordinates.
	var world_tile_pos := foreground_tile_offset + door_pos

	_set_rotated_tile(
		world_tile_pos,
		OPEN_DOOR_TILE,
		rotation_steps,
		tile_map_layer
	)
	print(
	"DOOR CELL: ", door_pos,
	" tile data: ", tile_map_layer.get_cell_atlas_coords(door_pos),
	" source: ", tile_map_layer.get_cell_source_id(door_pos)
	)

	# Draw the doorframe in the shared foreground layer.
	if is_instance_valid(foreground_layer):
		var global_tile_position := tile_map_layer.to_global(tile_map_layer.map_to_local(door_pos))
		var foreground_pos := foreground_layer.local_to_map(foreground_layer.to_local(global_tile_position))

		print(
			"FRAME: room=", position,
			" door=", door_pos,
			" offset=", foreground_tile_offset,
			" foreground=", foreground_pos,
			" atlas=", DOORFRAME_TILE
		)

		_set_rotated_tile(
			foreground_pos,
			DOORFRAME_TILE,
			rotation_steps,
			foreground_layer
		)

		_foreground_positions.append(foreground_pos)
	_foreground_positions.append(world_tile_pos)


func _set_rotated_tile(
	tile_pos: Vector2i,
	atlas_coords: Vector2i,
	rotation_steps: int,
	tile_map_layer: TileMapLayer
) -> void:
	var alternative_tile := 0

	match rotation_steps:
		ROTATE_NORTH:
			alternative_tile = 0

		ROTATE_EAST:
			alternative_tile = (
				TileSetAtlasSource.TRANSFORM_TRANSPOSE
				| TileSetAtlasSource.TRANSFORM_FLIP_H
			)

		ROTATE_SOUTH:
			alternative_tile = (
				TileSetAtlasSource.TRANSFORM_FLIP_H
				| TileSetAtlasSource.TRANSFORM_FLIP_V
			)

		ROTATE_WEST:
			alternative_tile = (
				TileSetAtlasSource.TRANSFORM_TRANSPOSE
				| TileSetAtlasSource.TRANSFORM_FLIP_V
			)
	print(
		"SET TILE: pos=", tile_pos,
		" atlas=", atlas_coords,
		" source=", tile_map_layer.get_instance_id()
	)
	tile_map_layer.set_cell(
		tile_pos,
		0,
		atlas_coords,
		alternative_tile
	)


func regenerate(north, east, south, west) -> void:
	print("MAP MANAGER RECEIVED: ", north, east, south, west)

	north_door = north
	east_door = east
	south_door = south
	west_door = west

	generate_room()


func set_transition_enabled(
	direction: Vector2i,
	enabled: bool
) -> void:
	var area: Area2D

	match direction:
		Vector2i.UP:
			area = north_area
		Vector2i.RIGHT:
			area = east_area
		Vector2i.DOWN:
			area = south_area
		Vector2i.LEFT:
			area = west_area
		_:
			push_warning("Invalid transition direction: " + str(direction))
			return

	if not is_instance_valid(area):
		push_warning(
			"Transition Area2D is missing for direction: "
			+ str(direction)
		)
		return

	area.visible = enabled
	area.monitoring = enabled


func _on_transition_entered(
	body: Node2D,
	direction: Vector2i
) -> void:
	if not body.is_in_group("player"):
		return

	if body.velocity.dot(Vector2(direction)) <= 0:
		return

	player_exited.emit(direction)
