extends Resource
class_name NPCData

@export var npc_name: String
@export var spawn_position: Vector2i
@export var dialogue_lines: Array[String]

@export var npc_scene: PackedScene
@export var is_unique: bool
@export var is_interaction_enabled: bool
