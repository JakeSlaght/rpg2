extends CharacterBody2D
class_name NonPlayer

@export var purpose: Globals.NPCPurpose = Globals.NPCPurpose.QuestGiver
@export var npc_name : String = ""
@export var dialog_lines : Array[String] = []
@export var sprite = null
@onready var interaction_area: InteractionArea = %InteractionArea
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision: CollisionShape2D = %Collision

var has_collision: bool:
	set(value):
		has_collision = value
		if is_node_ready():
			collision.set_deferred("disabled", value)
			# collision.disabled = not value

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	animated_sprite_2d.play("default")

#func set_has_collision(value: bool) -> void:
	#print("NPC: ", npc_name, " Collision: ", value)
	#collision.set_deferred("disabled", not value)

func _on_interact() -> void:
	if npc_name != "" and dialog_lines.size() > 0:
		Bus.dialogue_display.emit(npc_name, dialog_lines)
