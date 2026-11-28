extends Control
class_name StartScreen

func _on_new_game_pressed() -> void:
	Bus.new_game_requested.emit()

func _on_quit_pressed() -> void:
	Bus.quit_requested.emit()
