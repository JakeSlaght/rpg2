extends Control
class_name CharacterCreationTerminal

@export var class_details_row_scene: PackedScene
@onready var class_details: VBoxContainer = %ClassDetails
@onready var mana: Label = %Mana
@onready var health: Label = %Health
@onready var character_animation: AnimatedSprite2D = %CharacterAnimation
@onready var character_name: LineEdit = %CharacterName

var character_data: CharacterData

func _ready() -> void:
	character_name.text_changed.connect(_on_character_name_changed)
	character_name.focus_entered.connect(_on_character_name_input_focus_entered)

func _on_character_name_changed(new_text: String) -> void:
	character_data.character_name = new_text
	
func _on_character_name_input_focus_entered() -> void:
	character_name.caret_column = character_name.text.length()
	
func setup(character: CharacterData) -> void:
	if character == null:
		push_error("CharacterCreationTerminal: No CharacterData provided.")
		return

	character_data = character

	populate_class_details()
	update_character_display()
	await get_tree().process_frame
	character_name.grab_focus()
	
func update_character_display() -> void:
	character_name.text = character_data.character_name
	character_animation.sprite_frames = character_data.sprite_frames

	health.text = "Health: %d / %d" % [ character_data.health.current, character_data.health.current_max ]
	mana.text = "Mana: %d / %d" % [ character_data.mana.current, character_data.mana.current_max ]

func populate_class_details() -> void:
	for class_data in character_data.classes:
		var row = class_details_row_scene.instantiate()
		class_details.add_child(row)
		row.setup(class_data)
