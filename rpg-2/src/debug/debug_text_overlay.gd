extends Control

const VERSION_SETTING : String = "application/config/version"
const PROJECT_NAME    : String = "application/config/name"

@onready var fps_label: Label = %FPSLabel
@onready var version_info: Label = %VersionInfo
@onready var project_info: Label = %ProjectInfo

func _ready() -> void:
	_add_version_to_info_label()
	_add_project_name_to_label()

func _process(delta: float) -> void:
	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))

func _add_version_to_info_label() -> void:
	var version_str : String = ProjectSettings.get_setting(VERSION_SETTING)
	version_info.text += version_str
	
func _add_project_name_to_label() -> void:
	var project_name_str : String = ProjectSettings.get_setting(PROJECT_NAME)
	project_info.text += project_name_str
