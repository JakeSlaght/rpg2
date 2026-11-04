extends CharacterBody2D
class_name NonPlayer

@export var purpose: Globals.NPCPurpose = Globals.NPCPurpose.QuestGiver
@export var npc_name : String = ""
@export var dialog_lines : Array[String] = []
@export var sprite = null
@onready var interaction_area: InteractionArea = %InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	if npc_name != "" and dialog_lines.size() > 0:
		Bus.dialogue_display.emit(npc_name, dialog_lines)
