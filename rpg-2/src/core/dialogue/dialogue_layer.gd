extends CanvasLayer

@onready var dialogue_panel: PanelContainer = %DialoguePanel
@onready var speaker_name: Label = %DialoguePanel.get_node("%Speaker")
@onready var dialogue_text: RichTextLabel = %DialoguePanel.get_node("%DialogueText")
@onready var continue_prompt: Label = %DialoguePanel.get_node("%InteractPrompt")

var dialogue_lines: Array[String] = []
var current_line: int = 0
var dialogue_active: bool = false


func _ready() -> void:
	dialogue_panel.hide()
	Bus.dialogue_display.connect(start_dialogue)

func start_dialogue(speaker: String, lines: Array[String]) -> void:
	if lines.is_empty():
		return

	speaker_name.text = speaker
	dialogue_lines = lines
	current_line = 0
	dialogue_active = true

	dialogue_panel.show()
	_show_current_line()


func _input(event: InputEvent) -> void:
	if not dialogue_active:
		return

	if event.is_action_pressed("interact") and not event.is_echo():
		get_viewport().set_input_as_handled()
		advance_dialogue()


func advance_dialogue() -> void:
	current_line += 1

	if current_line >= dialogue_lines.size():
		end_dialogue()
		return

	_show_current_line()


func _show_current_line() -> void:
	dialogue_text.text = dialogue_lines[current_line]


func end_dialogue() -> void:
	dialogue_active = false
	dialogue_panel.hide()
	dialogue_lines.clear()
