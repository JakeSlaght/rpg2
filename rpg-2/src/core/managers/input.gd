class_name InputManager
extends Node

signal input_received(event: InputEvent)

func _unhandled_input(event: InputEvent) -> void:
	input_received.emit(event)
	
	if event.is_action_pressed("debug"):
		Debug.toggle()
		get_viewport().set_input_as_handled()


## Returns the player's movement direction based on the current input bindings.
func get_move_direction() -> Vector2:
	return Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)


## Returns true while an input action is being held.
func is_action_pressed(action: StringName) -> bool:
	return Input.is_action_pressed(action)


## Returns true on the frame an input action is initially pressed.
func is_action_just_pressed(action: StringName) -> bool:
	return Input.is_action_just_pressed(action)


## Returns true on the frame an input action is released.
func is_action_just_released(action: StringName) -> bool:
	return Input.is_action_just_released(action)
