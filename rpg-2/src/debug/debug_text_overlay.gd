extends Control

const VERSION_SETTING : String = "application/config/version"
const PROJECT_NAME    : String = "application/config/name"

@onready var fps_label: Label = %FPSLabel
@onready var version_info: Label = %VersionInfo
@onready var project_info: Label = %ProjectInfo
@onready var text_input_info: Label = %TextInputInfo

func _ready() -> void:
	Debug.debug_toggled.connect(_on_debug_toggled)
	InputGlobal.input_received.connect(_on_input_received)
	_on_debug_toggled(Debug.enabled)

func _process(delta: float) -> void:
	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))

func _on_debug_toggled(value: bool) -> void:
	visible = value
	
	if value == true:
		_add_version_to_info_label()
		_add_project_name_to_label()

func _on_input_received(event: InputEvent) -> void:
	if not Debug.enabled:
		return

	var actions := InputMap.get_actions()
	var matched_actions: Array[String] = []

	for action in actions:
		if event.is_action(action):
			matched_actions.append(action)

	text_input_info.text = "Input: %s\nActions: %s" % [
		_get_event_name(event),
		", ".join(matched_actions)
	]


func _get_event_name(event: InputEvent) -> String:
	return event.as_text()


func _add_version_to_info_label() -> void:
	var version_str : String = ProjectSettings.get_setting(VERSION_SETTING)
	version_info.set_text("v" + version_str)
	
func _add_project_name_to_label() -> void:
	var project_name_str : String = ProjectSettings.get_setting(PROJECT_NAME)
	project_info.set_text("Project: " + project_name_str)
