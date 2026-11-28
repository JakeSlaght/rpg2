extends Node
class_name GameManager
@onready var map_manager: MapManager = %MapManager
@onready var party_manager: PartyManager = %PartyManager
@export var character_creation_scene: PackedScene
@export var interface_layer: CanvasLayer
@onready var world: Node2D = %World
@onready var start_screen: Control = %StartScreen

var current_game_mode: Globals.GameMode = Globals.GameMode.None
var character_creation_terminal: Control

func _ready() -> void:
	Bus.new_game_requested.connect(start_new_game)
	Bus.quit_requested.connect(quit_game)
	
	start_screen.show()
	world.hide()
	world.process_mode = Node.PROCESS_MODE_DISABLED

	set_game_mode(Globals.GameMode.Menu)

func start_new_game() -> void:
	create_starting_character()
	map_manager.generate_map()
	party_manager.set_active_character(0)
	
	start_screen.hide()
	world.process_mode = Node.PROCESS_MODE_INHERIT
	world.show()
	
	set_game_mode(Globals.GameMode.Exploration)

func create_starting_character() -> void:
	var character := CharacterData.new()
	character.character_name = "Test Name"
	character.sprite_frames = load("res://src/gameplay/Player/basic-slime.tres")
	character.health = Stat.new()
	character.mana = Stat.new()
	
	for class_type in Globals.ClassType.values():
		if class_type == Globals.ClassType.None:
			continue
		var class_data := ClassData.new()
		class_data.class_type = class_type
		class_data.level = 1 if class_type == Globals.ClassType.Warrior else 0
		class_data.xp = Stat.new()
		
		character.classes.append(class_data)

	party_manager.add_to_available_character_list(character)
	party_manager.add_to_active_roster(character)

func set_game_mode(new_mode: Globals.GameMode) -> void:
	if current_game_mode == new_mode:
		return

	var previous_mode := current_game_mode
	current_game_mode = new_mode

	Bus.game_mode_changed.emit(previous_mode, current_game_mode)

func open_character_creation() -> void:
	if is_instance_valid(character_creation_terminal):
		return
	
	character_creation_terminal = character_creation_scene.instantiate()
	interface_layer.add_child(character_creation_terminal)
	
	character_creation_terminal.setup(party_manager.get_active_character())

func _input(event: InputEvent) -> void:
	if current_game_mode != Globals.GameMode.Exploration:
		return

	if event.is_action_pressed("open_terminal") and not event.is_echo():
		open_character_creation()
		
func quit_game() -> void:
	get_tree().quit()
