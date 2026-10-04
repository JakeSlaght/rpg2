extends CanvasLayer

func _ready() -> void:
	Debug.debug_toggled.connect(_on_debug_toggled)
	_on_debug_toggled(Debug.enabled)


func _on_debug_toggled(value: bool) -> void:
	visible = value
