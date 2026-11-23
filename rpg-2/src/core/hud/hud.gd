extends Control
@onready var compact_hud: PanelContainer = %CompactHUD
@onready var expanded_hud: PanelContainer = %ExpandedHUD

var is_paused := false
var tween: Tween


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	expanded_hud.hide()
	expanded_hud.position.y = -expanded_hud.size.y


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not event.is_echo():
		toggle_pause()
		get_viewport().set_input_as_handled()


func toggle_pause() -> void:
	is_paused = not is_paused

	if tween and tween.is_running():
		tween.kill()

	if is_paused:
		expanded_hud.show()
		get_tree().paused = true
	else:
		get_tree().paused = false

	var target_y := 0.0 if is_paused else -expanded_hud.size.y

	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(
		expanded_hud,
		"position:y",
		target_y,
		0.25
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	if not is_paused:
		tween.finished.connect(expanded_hud.hide)
