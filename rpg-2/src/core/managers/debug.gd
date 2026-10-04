extends Node

signal debug_toggled(enabled: bool)

var enabled: bool = false:
	set(value):
		if enabled == value:
			return

		enabled = value
		debug_toggled.emit(enabled)


func toggle() -> void:
	enabled = not enabled


func enable() -> void:
	enabled = true


func disable() -> void:
	enabled = false
